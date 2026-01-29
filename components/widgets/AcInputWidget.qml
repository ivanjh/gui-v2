/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

AcWidget {
	id: root

	readonly property AcInputSystemInfo inputInfo: input?.inputInfo ?? null
	property AcInput input
	readonly property bool inputOperational: input && input.operational

	title: !!inputInfo ? Global.acInputs.sourceToText(inputInfo.source) : ""
	icon.source: !!inputInfo ? Global.acInputs.sourceIcon(inputInfo.source) : ""
	rightPadding: sideGaugeLoader.active ? Theme.geometry_overviewPage_widget_sideGauge_margins : 0
	quantityLabel.sourceType: VenusOS.ElectricalQuantity_Source_AcInputOnly
	quantityLabel.dataObject: inputOperational ? input : null
	quantityLabel.leftPadding: acInputDirectionIcon.visible ? (acInputDirectionIcon.width + Theme.geometry_acInputDirectionIcon_rightMargin) : 0
	phaseCount: inputOperational ? input.phases.count : 0
	enabled: !!inputInfo
	extraContentLoader.sourceComponent: Column {
		width: parent.width
		spacing: Theme.geometry_overviewPage_widget_extraContent_topMargin

		ThreePhaseDisplay {
			width: parent.width
			model: root.input.phases
			widgetSize: root.size
			inputMode: true
		}

		// Phase details (V/I/P) - visible only at M+ sizes
		Column {
			width: parent.width
			spacing: Theme.geometry_overviewPage_widget_extraContent_topMargin
			visible: root.size >= VenusOS.OverviewWidget_Size_M && root.inputOperational

			// L1 Phase Details
			Row {
				width: parent.width
				spacing: Theme.geometry_overviewPage_widget_content_horizontalMargin
				visible: l1Voltage.valid || l1Current.valid || l1Power.valid

				Label {
					width: 30
					text: "L1"
					color: Theme.color_font_primary
					font.pixelSize: Theme.geometry_font_size_body3
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Volt_AC
					value: l1Voltage.value
					visible: l1Voltage.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Amp
					value: l1Current.value
					visible: l1Current.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Watt
					value: l1Power.value
					visible: l1Power.valid
				}

				VeQuickItem {
					id: l1Voltage
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L1/Voltage" : ""
				}
				VeQuickItem {
					id: l1Current
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L1/Current" : ""
				}
				VeQuickItem {
					id: l1Power
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L1/Power" : ""
				}
			}

			// L2 Phase Details
			Row {
				width: parent.width
				spacing: Theme.geometry_overviewPage_widget_content_horizontalMargin
				visible: l2Voltage.valid || l2Current.valid || l2Power.valid

				Label {
					width: 30
					text: "L2"
					color: Theme.color_font_primary
					font.pixelSize: Theme.geometry_font_size_body3
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Volt_AC
					value: l2Voltage.value
					visible: l2Voltage.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Amp
					value: l2Current.value
					visible: l2Current.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Watt
					value: l2Power.value
					visible: l2Power.valid
				}

				VeQuickItem {
					id: l2Voltage
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L2/Voltage" : ""
				}
				VeQuickItem {
					id: l2Current
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L2/Current" : ""
				}
				VeQuickItem {
					id: l2Power
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L2/Power" : ""
				}
			}

			// L3 Phase Details
			Row {
				width: parent.width
				spacing: Theme.geometry_overviewPage_widget_content_horizontalMargin
				visible: l3Voltage.valid || l3Current.valid || l3Power.valid

				Label {
					width: 30
					text: "L3"
					color: Theme.color_font_primary
					font.pixelSize: Theme.geometry_font_size_body3
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Volt_AC
					value: l3Voltage.value
					visible: l3Voltage.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Amp
					value: l3Current.value
					visible: l3Current.valid
				}

				QuantityLabel {
					width: (parent.width - 30 - 3 * parent.spacing) / 3
					unit: VenusOS.Units_Watt
					value: l3Power.value
					visible: l3Power.valid
				}

				VeQuickItem {
					id: l3Voltage
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L3/Voltage" : ""
				}
				VeQuickItem {
					id: l3Current
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L3/Current" : ""
				}
				VeQuickItem {
					id: l3Power
					uid: root.input.measurementsUid ? root.input.measurementsUid + "/Ac/L3/Power" : ""
				}
			}
		}
	}

	onClicked: {
		const inputServiceUid = BackendConnection.serviceUidFromName(root.inputInfo.serviceName, root.inputInfo.deviceInstance)
		if (root.inputInfo.serviceType === "acsystem") {
			Global.pageManager.pushPage("/pages/settings/devicelist/rs/PageRsSystem.qml",
					{ "bindPrefix": inputServiceUid })
		} else if (root.inputInfo.serviceType === "vebus") {
			Global.pageManager.pushPage( "/pages/vebusdevice/PageVeBus.qml", {
				"bindPrefix": inputServiceUid
			})
		} else if (root.inputInfo.serviceType === "genset") {
			Global.pageManager.pushPage( "/pages/settings/devicelist/PageGenset.qml", {
				"bindPrefix": inputServiceUid
			})
		} else {
			// Assume this is on a generic AC input
			Global.pageManager.pushPage("/pages/settings/devicelist/ac-in/PageAcIn.qml", {
				"bindPrefix": inputServiceUid
			})
		}
	}

	Loader {
		id: sideGaugeLoader

		anchors {
			top: parent.top
			bottom: parent.bottom
			right: parent.right
			margins: Theme.geometry_overviewPage_widget_sideGauge_margins
		}
		active: root.inputOperational && root.size >= VenusOS.OverviewWidget_Size_M
		sourceComponent: ThreePhaseBarGauge {
			valueType: VenusOS.Gauges_ValueType_NeutralPercentage
			phaseModel: root.input.phases
			minimumValue: root.inputInfo?.minimumCurrent ?? NaN
			maximumValue: root.inputInfo?.maximumCurrent ?? NaN
			inputMode: true
			animationEnabled: root.animationEnabled
			inOverviewWidget: true
		}
	}

	Label {
		anchors {
			top: root.extraContent.top
			topMargin: Theme.geometry_overviewPage_widget_extraContent_topMargin
			left: root.extraContent.left
			leftMargin: Theme.geometry_overviewPage_widget_content_horizontalMargin
			right: root.extraContent.right
			rightMargin: Theme.geometry_overviewPage_widget_content_horizontalMargin
		}
		elide: Text.ElideRight
		text: root.inputInfo && root.inputInfo.source === VenusOS.AcInputs_InputSource_Generator
				? CommonWords.stopped
				: CommonWords.disconnected
		visible: !root.inputOperational
	}

	AcInputDirectionIcon {
		id: acInputDirectionIcon
		parent: root.quantityLabel
		anchors.verticalCenter: parent.verticalCenter
		input: root.input
	}
}
