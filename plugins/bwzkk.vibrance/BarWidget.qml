import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "bwzkk.vibrance"

  property bool vibranceOn: false
  property real saturation: 2.0

  function refresh() {
    if (!statusProc.running) statusProc.running = true
  }

  function toggle() {
    if (!root.bar) return
    // Optimistic flip so the icon responds immediately; verifyTimer
    // re-checks the real shader state shortly after.
    root.vibranceOn = !root.vibranceOn
    root.bar.run("omarchy-vibrance toggle")
    verifyTimer.restart()
  }

  function adjust(delta) {
    if (!root.bar) return
    root.bar.run("omarchy-vibrance " + (delta > 0 ? "inc" : "dec"))
    verifyTimer.restart()
  }

  Component.onCompleted: refresh()

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: statusProc
    command: ["omarchy-vibrance", "status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        const parts = text.trim().split(" ")
        root.vibranceOn = parts[0] === "on"
        if (parts[1]) root.saturation = parseFloat(parts[1])
      }
    }
  }

  Timer {
    id: verifyTimer
    interval: 500
    onTriggered: root.refresh()
  }

  Timer {
    interval: 20000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "V"
    dimmed: !root.vibranceOn
    tooltipText: "Vibrance: " + (root.vibranceOn ? "on" : "off") + " (" + root.saturation.toFixed(1) + ") · scroll to adjust"
    onPressed: root.toggle()
    onWheelMoved: function(delta) { root.adjust(delta) }
  }
}
