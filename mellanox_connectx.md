---
title: Mellanox ConnectX
description: Mellanox ConnectX-3/4
updated: 2025-12-24
visibility: public
status: wip
tags:
    - mellanox
    - connectx-3
    - connectx-4
    - infiniband
    - ethernet
---
# Mellanox ConnectX-3/4

中古市場で安価安定流通してるPCIe NIC 10~100G
ケーブルの互換性も良さそう??

InfiniBand 速度規格
| 略称                    | 年   | 1x速度   | 4X速度(実効)  | 特徴・世代         |
|-------------------------|------|----------|---------------|--------------------|
| QDR(Quad Data Rate)     | 2004 | 10 Gbps  | 40 Gbps       | ConnectX-2/3 世代  |
| FDR(Fourteen Data Rate) | 2012 | 14 Gbps  | 56 Gbps       | ConnectX-3 世代    |
| EDR(Enhanced Data Rate) | 2012 | 25 Gbps  | 100 Gbps      | ConnectX-4 世代    |


## 参考

[ConnectX-3Pro リリースノート](
https://network.nvidia.com/pdf/firmware/ConnectX3Pro-FW-2_42_5000-release_notes.pdf
)<br>
[ConnectX-3 リリースノート](
https://network.nvidia.com/pdf/firmware/ConnectX3-FW-2_42_5000-release_notes.pdf
)<br>
[ConnectX-4 Lx リリースノート](
https://docs.nvidia.com/networking/display/connectx4lxfirmwarev14321908
)<br>
[ConnectX-4 リリースノート](
https://docs.nvidia.com/networking/display/connectx4firmwarev12284704
)<br>
[Firmware Downloads](
https://network.nvidia.com/support/firmware/firmware-downloads/
)<br>

ファームウェア更新
> https://network.nvidia.com/support/firmware/nic/<br>
> https://network.nvidia.com/support/firmware/identification/<br>


## ConnectX-3

ConnectX®-3 VPI PCI Express Adapter Cards (InfiniBand, Ethernet, FCoE, VPI)
- 10~40G(56G)
- PCIe 3.0 x8

製品例
- ConnectX-3 CX311A sfp+
- ConnectX-3 CX312A sfp+ 2-port
- ConnectX-3 CX353A qsfp+
- ConnectX-3 CX354A qsfp+ 2-port

ザックリと、通常版とPro版それぞれ1/2ポートで４種類あるとも言える。
クロスフラッシュでモデルの変更できるらしい、ブリック化リスク？
通常版をPro版にはできない、基盤が違う。

lspci/mstflint
```
# PCI Device ID:
ConnectX-3:     4099
ConnectX-3 Pro: 4103
```

RDMA over Converged Ethernet (RoCE)サポート
- ConnectX-3:     RoCEv1(L2のみ)
- ConnectX-3 Pro: RoCEv2サポート(L2/L3)
> NVIDIA MLNX_OFED Documentation
> https://docs.nvidia.com/networking/display/mlnxofedv497100lts/rdma+over+converged+ethernet+(roce)


### ファームウェア

ファームウェア・バージョン確認
```
$ sudo apt install -y infiniband-diags rdma-core mstflint opensm
$ sudo mstflint -d 20:00.0 q
Image type:            FS2
FW Version:            2.40.5030
FW Release Date:       4.1.2017
Product Version:       02.40.50.30
Rom Info:              type=PXE version=3.4.746
Device ID:             4099
Description:           Node             Port1            Port2            Sys image
GUIDs:                 ec0d9a0300f00620 ec0d9a0300f00621 ec0d9a0300f00622 ec0d9a0300f00623
MACs:                                       ec0d9af00621     ec0d9af00622
VSD:
PSID:                  ISL1090110018
```

[mstflint](
https://github.com/Mellanox/mstflint
)<br>


### Infiniband

ツールのインストールとサブネットマネージャの開始
```
# ２枚のカードをPCに付けて、DAC直結の想定で
sudo apt install -y opensm  # いずれか１台のみインストール
sudo ibstat
sudo systemctl start opensm
sudo ibstat
ip -br link
```


### IB/EN切り替え

```
# 現状確認
sudo mstconfig -e query
Device #1:
----------

Device type:    ConnectX3Pro    
Device:         /sys/bus/pci/devices/0000:20:00.0/config

Configurations:                              Default         Next Boot
         SRIOV_EN                            True(1)         True(1)         
         NUM_OF_VFS                          16              16              
         LINK_TYPE_P1                        VPI(3)          VPI(3)          
         LINK_TYPE_P2                        VPI(3)          VPI(3)          
         LOG_BAR_SIZE                        5               5               
         BOOT_PKEY_P1                        0               0               
         BOOT_PKEY_P2                        0               0               
         BOOT_OPTION_ROM_EN_P1               True(1)         True(1)         
         BOOT_VLAN_EN_P1                     False(0)        False(0)        
         BOOT_RETRY_CNT_P1                   0

# Ethernetモードに切り替え
# 1 IB
# 2 Ether
# 3 VIP
sudo mstconfig -d 20:00.0 set LINK_TYPE_P1=2 LINK_TYPE_P2=2
```
> Ethernetが扱いやすいんじゃないか<br>
> しかしEthernetだとリンク上がらない、FWの問題？？<br>
> EthernetにしないでIP over IBでいいかも<br>
<br>
> mstconfig – Changing Device Configuration Tool<br>
> https://docs.nvidia.com/networking/display/mft/mstconfig+%E2%80%93+changing+device+configuration+tool<br>
> Using mstconfig<br>
> https://docs.nvidia.com/networking/display/mft/using+mstconfig<br>


### 対応ケーブル

- DAC (Direct Attach Copper) 安価、短距離向け
- AOC (Active Optical Cable) 長距離向け
- SR4（Short Reach 4-lane）モジュール
- QSAアダプタ (QSFP to SFP+ Adapter)
- QSFP+モジュール + 光ファイバー (LC-LC)
    - P2Pの場合はクロス
    - 例: MPOケーブル（Type-B Female-Female OM3）
    - ブレイクアウトケーブルはOSやドライバの制限あるかも

- 純正
- アリエクなど互換ケーブル
- Dell, HP, Cisco, FS.com等も動きそう

[ConnectX-3 リリースノート](
https://network.nvidia.com/pdf/firmware/ConnectX3-FW-2_42_5000-release_notes.pdf
)
> 1.1 Supported Devices

[Mellanox ConnectX-3 - Unsupported Cable but replugging many times eventually works? ...and how to update firmware? ](
https://www.reddit.com/r/homelab/comments/1dzvwbf/mellanox_connectx3_unsupported_cable_but/
)

[3rd party SFP利⽤の光と闇](
https://www.janog.gr.jp/meeting/janog54/wp-content/uploads/2024/05/janog54-3rdparty-konuma.pdf
)

[サードパーティ製トランシーバのロック解除コマンドとサポートまとめ](
https://network-arekore.com/?p=3250
)

[Anyone Try SFPTotal for reprograming SFP transceivers? ](
https://www.reddit.com/r/homelab/comments/uhhcgy/anyone_try_sfptotal_for_reprograming_sfp/
)

### 対応スイッチ

[ConnectX-3 リリースノート](
https://network.nvidia.com/pdf/firmware/ConnectX3-FW-2_42_5000-release_notes.pdf
)
> 1.3 Tested Switches

1. メーカー例
    - Mellanox
    - Juniper
    - IBM
    - Brocade
    - Cisco
    - Dell
    - HP
2. 製品例
    - Mellanox SX6036 36 port FDR 56Gb/40GbE [Mellanox SwitchX Hardware User Manual](
    https://network.nvidia.com/pdf/user_manuals/1U_HW_UM_SX60XX.pdf
    )
    - Mellanox SB7700 36 port EDR 100Gb/s [1U EDR SB7XX0 100Gb/s InfiniBand Switch](
    https://docs.nvidia.com/networking/display/sb77x0edr
    )


## ConnectX-4

25G ~ 100G

通常版とLx版 違いは？

