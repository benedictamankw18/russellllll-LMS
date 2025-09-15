<%@ Page Title="" Language="C#" MasterPageFile="~/Teacher/Site1.Master" AutoEventWireup="true" CodeBehind="GradeRange.aspx.cs" Inherits="LMS.Teacher.GradeRange" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4">Grade Range Setup</h2>
        <asp:GridView ID="gvGradeRanges" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped" OnRowCommand="gvGradeRanges_RowCommand" OnRowUpdating="gvGradeRanges_RowUpdating">
            <Columns>
                <asp:BoundField DataField="Grade" HeaderText="Grade" />
                <asp:TemplateField HeaderText="Start (%)">
                    <ItemTemplate>
                        <asp:TextBox ID="txtStart" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("Start") %>' Width="70px" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="End (%)">
                    <ItemTemplate>
                        <asp:TextBox ID="txtEnd" runat="server" CssClass="form-control form-control-sm" Text='<%# Eval("End") %>' Width="70px" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-sm btn-primary" Text="Update" CommandName="Update" CommandArgument='<%# Eval("Grade") %>' CausesValidation="false" UseSubmitBehavior="false" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    <asp:Button ID="btnResetDefault" runat="server" CssClass="btn btn-secondary mt-3" Text="Reset to Default (A-F)" OnClick="btnResetDefault_Click"/>
        <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
    </div>
</asp:Content>
