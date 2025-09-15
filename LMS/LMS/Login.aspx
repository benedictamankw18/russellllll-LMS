<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LMS.Login" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>LMS Login</title>
    <link rel="stylesheet" href="main.css" />
    <link rel="stylesheet" href="bootstrap-compat.css" />
    <style>
        body {
            background: url('./Image/download.jpeg') no-repeat center center fixed;
            background-size: cover;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 8px;
            box-shadow: 0 0 10px #ccc;
        }
        .logo {
            display: block;
            margin: 0 auto 20px auto;
            max-width: 120px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container text-center">
            <img src="Image/uew_logo.png" alt="LMS Logo" class="logo" />
            <h3 class="mb-4">Login</h3>
            <asp:Label ID="lblError" runat="server" CssClass="text-danger" />
            <div class="mb-3">
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
            </div>
            <div class="mb-3 position-relative">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control pe-5" TextMode="Password" placeholder="Password" />
                <button type="button" class="btn position-absolute bg-transparent" id="togglePassword" style="z-index: 5; right: 7px; top: 50%; transform: translateY(-50%);">
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                        <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                    </svg>
                </button>
            </div>
            <div class="d-grid">
                <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-primary" Text="Login" OnClick="btnLogin_Click" />
            </div>
        </div>
    </form>
    <script>
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const toggleBtn = this;
            const eyeIcon = toggleBtn.querySelector('svg');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.innerHTML = '<path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7.028 7.028 0 0 0-2.79.588l.77.771A5.944 5.944 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13.134 13.134 0 0 1 14.828 8c-.058.087-.122.183-.195.288-.335.48-.83 1.12-1.465 1.755-.165.165-.337.328-.517.486l.708.709z"/><path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829l.822.822zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829z"/><path d="M3.35 5.47c-.18.16-.353.322-.518.487A13.134 13.134 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7.029 7.029 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.708zm10.296 8.884-12-12 .708-.708 12 12-.708.708z"/>';
            } else {
                passwordField.type = 'password';
                eyeIcon.innerHTML = '<path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>';
            }
        });
    </script>
</body>
</html>