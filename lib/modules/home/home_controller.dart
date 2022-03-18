// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:sdp_transform/sdp_transform.dart';

class HomeController extends GetxController {
  bool isOffer = false;
  final session2 = ''.obs;
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  final ref = FirebaseFirestore.instance.collection("rooms");
  var roomId = ''.obs;
  final RtCVideos = [].obs;

  @override
  void onClose() {
    localRenderer.dispose();
    super.onClose();
  }

  @override
  Future<void> onInit() async {
    initRenderer();
    peerConnection = await CreatePeerConnection();
    peerConnection!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
    };
    super.onInit();
  }

  Future<RTCPeerConnection> CreatePeerConnection() async {
    //creating peer connection
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };
    Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };
    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    localStream = await _getUserMedia();
    pc.addStream(localStream!);

    return pc;
  }

  Future<void> initRenderer() async {
    //initializing renderers
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<String> createRoom() async {
    final roomRef = ref.doc();
    peerConnection = await CreatePeerConnection();
    //getting caller ice candidates below
    final callerCandidatesRef = roomRef.collection('CallerCandidates');
    peerConnection!.onIceCandidate =
        (candidate) => callerCandidatesRef.add(candidate.toMap());
    //setting local description below
    RTCSessionDescription description = await peerConnection!.createOffer();
    peerConnection!.setLocalDescription(description);
    //creating a room in firebase below
    final roomWithOffer = {'description': description.toMap()};
    await roomRef.set(roomWithOffer);
    final String roomId = roomRef.id;
    //listening to remote description below
    roomRef.snapshots().listen((event) async {
      final data = event.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );
        await peerConnection!.setRemoteDescription(answer);
      }
    });
    //listening to remote ice candidates below
    roomRef.collection('recieverCandidates').snapshots().listen((event) {
      event.docChanges.forEach((change) {
        final data = change.doc.data() as Map;
        if (change.type == DocumentChangeType.added) {
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });
    return roomId;
  }

  joinRoom(String roomId) async {
    final roomRef = ref.doc(roomId);
    final roomSnapshot = await roomRef.get();
    if (roomSnapshot.exists) {
      final peerConnection = await CreatePeerConnection();
      //collecting ice candidates below
      final recieverRef = roomRef.collection('recieverCandidates');
      peerConnection.onIceCandidate =
          (candidate) async => await recieverRef.add(candidate.toMap());
      //creating sdp answer below
      final data = roomSnapshot.data() as Map;
      final offer = data['description'];
      print(offer);
      await peerConnection.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      final answer = await peerConnection.createAnswer();
      await peerConnection.setLocalDescription(answer);
      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      //listening to remote ice candidates below
      roomRef.collection('CallerCandidates').snapshots().listen((event) {
        event.docChanges.forEach((change) {
          final data = change.doc.data() as Map;
          peerConnection.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }
}
