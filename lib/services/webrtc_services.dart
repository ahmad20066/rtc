// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebRtcServices {
  final config = {
    'iceServers': [
      {"url": "stun:stun.l.google.com:19302"},
    ]
  };
  connectSocket(IO.Socket socket, RTCPeerConnection peerConnection) {
    socket = IO.io(
      'http://localhost:3000',
    );
    socket.onConnect((data) => print(data));
    socket.on('offer', (offer) async {
      final data = jsonDecode(offer);
      await setRemoteDescription(
          peerConnection, RTCSessionDescription(data['sdp'], data['type']));
      await sendAnswer(peerConnection, socket);
    });
    socket.on('answer', (answer) async {
      final data = jsonDecode(answer);
      await setRemoteDescription(
          peerConnection, RTCSessionDescription(data['sdp'], data['type']));
    });
    socket.on('ice', (candidates) async {
      final data = jsonDecode(candidates);
      await gotIceCandidates(
          peerConnection,
          RTCIceCandidate(
              data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
    });
  }

  Future<MediaStream> getUserMedia(localRenderer) async {
    //camera setup
    final constraints = {
      'audio': false,
      'video': {'facing mode': 'user'}
    };
    MediaStream stream = await MediaDevices.getUserMedia(constraints);
    localRenderer.srcObject = stream;
    return stream;
  }

  createCall(localRenderer) async {
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    final peerConnection =
        await createPeerConnection(config, offerSdpConstraints);
    final localStream = await getUserMedia(localRenderer);
    peerConnection.addStream(localStream);
    return peerConnection;
  }

  sendOffer(RTCPeerConnection peerConnection, IO.Socket socket) async {
    final description =
        await peerConnection.createOffer({'offerToReceiveVideo': 1});
    peerConnection.setLocalDescription(description);
    socket.emit('offer', jsonEncode(description.toMap()));
  }

  sendAnswer(RTCPeerConnection peerConnection, IO.Socket socket) async {
    final answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);
    socket.emit('answer', jsonEncode(answer.toMap()));
  }

  Future<void> setRemoteDescription(
      RTCPeerConnection peerConnection, remoteDesciption) async {
    await peerConnection.setRemoteDescription(remoteDesciption);
  }

  Future sendIceCandidates(RTCIceCandidate candidate, IO.Socket socket) async {
    socket.emit('ice', jsonEncode(candidate.toMap()));
  }

  Future gotIceCandidates(
      RTCPeerConnection peerConnection, RTCIceCandidate candidate) async {
    peerConnection.addCandidate(candidate);
  }
}
