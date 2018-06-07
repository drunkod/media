extern crate rand;
extern crate servo_media;

use servo_media::audio::buffer_source_node::AudioBufferSourceNodeMessage;
use servo_media::audio::node::{AudioNodeMessage, AudioNodeType};
use servo_media::ServoMedia;
use std::sync::Arc;
use std::{thread, time};

fn run_example(servo_media: Arc<ServoMedia>) {
    let mut graph = servo_media.create_audio_graph();
    let buffer_source = graph.create_node(AudioNodeType::AudioBufferSourceNode);
    let mut buffer = Vec::with_capacity(4096);
    for _ in 0..4096 {
        buffer.push(rand::random::<f32>());
    }
    graph.message_node(
        buffer_source,
        AudioNodeMessage::AudioBufferSourceNode(AudioBufferSourceNodeMessage::Start(0.)),
    );
    graph.message_node(
        buffer_source,
        AudioNodeMessage::AudioBufferSourceNode(AudioBufferSourceNodeMessage::SetBuffer(buffer)),
    );
    graph.resume();
    thread::sleep(time::Duration::from_millis(5000));
    graph.close();
}

fn main() {
    if let Ok(servo_media) = ServoMedia::get() {
        run_example(servo_media);
    } else {
        unreachable!()
    }
}