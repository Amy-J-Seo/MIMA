<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
  <title></title>
  
</head>
<body style="background-image: url(images/background4.jpg);">
<br>

<br>

<form method="post" action="generateprescription.php"><big><big>PRESCRIPTION :<br>
  <br>
  </big></big>
  <table width="50%">
    <tbody>
		<tr>
        <td>Doctor Name : <br>
        </td>
        <td><input name="doc_name" type="text"><br>
        </td>
      </tr>
      <tr>
        <td>Patient ID : <br>
        </td>
        <td><input name="id" type="text"><br>
        </td>
      </tr>
      <tr>
        <td>Medicine : <br>
        </td>
        <td><textarea cols="30" rows="3" name="medicine"></textarea><br>
        </td>
      </tr>
      <tr>
        <td>Dosage : <br>
        </td>
        <td>
		<input name="dose" type="checkbox"> Morning<br>
        <input name="dose" type="checkbox"> Afternoon<br>
        <input name="dose" type="checkbox"> Night<br>
        </td>
      </tr>
      <tr>
        <td>Diagnosis :<br>
        </td>
        <td><textarea cols="30" rows="3" name="diagnosis"></textarea><br>
        </td>
      </tr>
      <tr>
        <td>Additional Instructions :<br>
        </td>
        <td><textarea cols="30" rows="3" name="instructions"></textarea> </td>
      </tr>
    </tbody>
  </table>
  <br>
  <br>
  <input name="submit" value="Generate Prescription" type="submit">&nbsp; &nbsp; <input name="reset" value="RESET" type="reset"> <big><big><br>
  </big></big></form>

</body>
</html>