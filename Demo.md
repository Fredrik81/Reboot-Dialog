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
Transparent = 0.95
FontColor = #FFFFFF
BackgroundColor = #FF303946
</pre>
</td>
<td>
<pre lang="php">
TextShadows = True
Transparent = 0.95
FontColor = #111111
BackgroundColor = #EEEEEE
</td>
<td>
<pre lang="php">
TextShadows = True
Transparent = 0.95
FontColor = #111111
BackgroundColor = #EEEEEE
</pre>
</td>
</tr></tbody></table>

## Picture/Logo
<table>
<thead>
<tr>
<th align="center">abc</th>
<th align="right">defghi</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">bar</td>
<td align="right">baz</td>
</tr></tbody></table>

## Transparency
<pre><code data-language="javascript">
<setting name="TextShadows" serializeAs="String">
    <value>True</value>
</setting>
<setting name="Transparent" serializeAs="String">
    <value>0.95</value>
</setting>
<setting name="FontColor" serializeAs="String">
    <value>#FFFFFF</value>
</setting>
<setting name="BackgroundColor" serializeAs="String">
    <value>#FF303946</value>
</setting>
</code></pre>
