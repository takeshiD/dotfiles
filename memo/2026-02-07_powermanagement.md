
```bash
upower -b >> powers/$(hostname).log
```

# Thinkpad X1 Carbon Gen13 Aura Edition
| Name   | Description             |
| ------ | -------------           |
| CPU    | Intel Core Ultra 7 258V |

## Record
| date           | power(Wh) | State   |
| ------         | -----     | ------  |
| 02/07 11:36:39 | 50.03     | Suspend |
| 02/07 13:40:52 | 45.50     | Suspend |
| 02/07 15:43:58 | 41.35     | Suspend |

おおよそsuspendで2Whとなっており、非常に消費電力が大きい。
これはUEFIがs3(deep sleep)をサポートしていないためである。

ハードウェアレイヤーとの関係性は以下で、nixosはsystemdのレイヤーまでしか制御できない(はず)
```txt
High
┌─────────────────────────────┐
│ アプリ / systemd            │
│  systemctl suspend          │
├─────────────────────────────┤
│ Linux kernel (PM core)      │
│  mem_sleep: s2idle / deep   │
├─────────────────────────────┤
│ ACPI / firmware (UEFI)      │
│  S0ix / S3 exposed or not   │
├─────────────────────────────┤
│ SoC / CPU / PCH / DRAM      │
│  電源レール・C-state        │
└─────────────────────────────┘
Low
```

# ACPI - Advanced Coniguration and Power Interface
> [Wikipedia - ACPI](https://ja.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface)
> [UEFI - Specification](https://uefi.org/specifications)
> []
