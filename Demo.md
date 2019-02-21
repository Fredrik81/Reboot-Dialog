# Demo of custimizations
All customizations is done in the configuration file "Reboot Dialog.exe.config"<br/>

## Colors
<table>
<thead>
<tr>
<th align="center">Original</th>
<th align="center">Black & White</th>
<th align="center">Dark Blue & White</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<pre lang="php">
TextShadows = True
FontColor = #FFFFFF
BackgroundColor = #FF303946
</pre>
</td>
<td>
<pre lang="php">
TextShadows = False
FontColor = #FFFFFF
BackgroundColor = #000000
</td>
<td>
<pre lang="php">
TextShadows = True
FontColor = #FFFFFF
BackgroundColor = #334d93
</pre>
</td>
</tr><tr>
    <td><img src=/Images/demo_Color_Original.png /></td>
    <td><img src=/Images/demo_Color_BlackWhite.png /></td>
    <td><img src=/Images/demo_Color_BlueWhite.png /></td>
</tbody></table>

## Picture/Logo
You can change the default picture with something else like your company logo by adding a Picture.PNG file to same folder as the binary.<br/>
Download example picture: [Picture.PNG](/Images/Picture.PNG)<br/>
![Picture Demo](/Images/demo_Picture.png)

## Transparency
All the pictures have a white word document in the background to show the transparency.<br/>

<table>
<thead>
<tr>
<th align="center">25%</th>
<th align="center">50%</th>
<th align="center">75%</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<pre lang="php">
Transparent = 0.25
</pre>
</td>
<td>
<pre lang="php">
Transparent = 0.50
</td>
<td>
<pre lang="php">
Transparent = 0.75
</pre>
</td>
</tr><tr>
    <td><img src=/Images/demo_transparent_25.png /></td>
    <td><img src=/Images/demo_transparent_50.png /></td>
    <td><img src=/Images/demo_transparent_75.png /></td>
</tbody></table>
