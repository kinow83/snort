
<html>
<body>
	
<?php
session_start();

if (!isset($_SESSION['username'])) {
?>
	<form action="login.php" method="post">
		Username: <input type="text"     name="username" size="10" required />
		Password: <input type="password" name="password" size="10" required />
		<input type="submit" name="login" value="Login" />
	</form>

<?php
} else {
	echo "Welcom ".$_SESSION['username'];
?>
	<input type="button" value="Logout" onclick="location.href='login.php'">
	<input type="button" value="Write" onclick="location.href='write.php'">
<?php
}
?>
<br/><br/>

<table width="580" border="1px" cellpadding="2" style="border-collapse: collapse;">
	<thead>
		<tr align="center">
			<th width="30">number</th>
			<th width="300">title</th>
			<th width="50">name</th>
			<th width="60">date</th>
		</tr>
	</thead>
	<tbody>
<?php
	$con = mysqli_connect('localhost', 'root', 'kaka0421', 'sample');
	$result = mysqli_query($con, "SELECT * FROM board order by id desc");
	while ($row = mysqli_fetch_array($result)) {
?>
		<tr align="center">
			<td><?=$row[id]?></td>
			<td>
				<a href="view.php?id=<?=$row[id]?>">
				<?=$row[title]?>
			</td>
			<td><?=$row[user]?></td>
			<td><?=$row[date]?></td>
		</tr>
<?php
	}
?>
	</tbody>
</table>

</body>
</html>
