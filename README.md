<div align="center">
<img width="120" height="120" alt="CopyBear (Image Credits: Microsoft Bing Image Creator)" src="https://github.com/user-attachments/assets/20a7118c-bca9-41fc-b13e-764228e885c9">
<h1>CopyBear</h1>
</div>
A macOS menu bar app that tracks clipboard history so you can go back in time and find anything you copied.

## Why CopyBear ⁉️
I spent some time writing a really good description for a merge request at work but needed to make a few little changes before creating the MR so I decided against creating a draft MR (rookie mistake). Instead, I copied the description and made a mental note to avoid copying any other thing until after I create the MR.

Well, the mental note sure didn't stick. I CMD+V'd another stuff and lost my really good MR description. I then tried to see if macOS had a clipboard history so I can retrieve my really good description. Answer is no. I got pissed, rewrote the description and made another mental note to build something that maintains clipboard history. That mental note stuck, hence **CopyBear**.

## Demo 📸
<img src="https://raw.githubusercontent.com/Crazelu/copybear/main/Screenshots/demo.gif" alt="CopyBear demo">

## Features  ✨
- [x] Clipboard history for texts, URLs, images, videos, documents and other files. If you can CMD + C it, CopyBear should be able to track it.
- [x] Auto launch startup. CopyBear registers itself as a login item so that when your computer is restarted, CopyBear launches in the background to keep tracking your clipboard history.
- [x] Open/close CopyBear from anywhere with CMD + SHIFT + V
