import React, { Component } from "react";

class AccountPage extends React.Component {
  render() {
    const userInfo = JSON.parse(window.localStorage.getItem("userInfo"));
    return (
      <div>
        <h1>Employee Account Page</h1>
        <br></br>
        <p>Fullname: {userInfo.fullname}</p>
        <p>Email: {userInfo.email}</p>
        <p>Branch Id: {userInfo.branchId}</p>
        <p>Salary: {userInfo.salary}$</p>
      </div>
    );
  }
}

export default AccountPage;
