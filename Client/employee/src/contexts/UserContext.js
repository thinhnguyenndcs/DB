import React, { Component, createContext } from "react";
import $ from "jquery";
import { withRouter } from "react-router";

export const UserContext = createContext();

class UserProvider extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      userInfo: {
        id: "",
        fullname: "",
        salary: "",
        branchId: "",
        managerId: "",
        email: "",
      },
      userToken: "",
    };
  }

  registerUser = async (data) => {
    let __this = this;
    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/employee/register`,
      data: {
        email: data.email,
        password: data.password,
        fullname: data.fullname,
        salary: data.salary,
        branchId: data.branchId,
        managerId: null,
      },
      headers: {},
    };
    let response = await $.ajax(settings);
    response = JSON.parse(response);
    return response;
  };

  loginUser = async (data) => {
    let __this = this;
    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/employee/login`,
      data: {
        email: data.email,
        password: data.password,
      },
      headers: {},
    };
    let response = await $.ajax(settings);
    response = JSON.parse(response);
    if (response.status == 200) {
      const result = response.response;
      const newUserInfo = {
        id: result.Id,
        fullname: result.Fullname,
        salary: result.Salary,
        branchId: result.BranchId,
        managerId: result.ManagerId,
        email: result.Email,
      };
      const newUserToken = response.token;
      this.setState({
        userInfo: newUserInfo,
        userToken: newUserToken,
      });

      window.localStorage.setItem("userInfo", JSON.stringify(newUserInfo));
      window.localStorage.setItem("userToken", JSON.stringify(newUserToken));

      this.props.history.push("/items");
      return response;
    } else {
      alert("Invalid Login Password or Email");
      return response;
    }
  };

  logoutUser = () => {
    window.localStorage.removeItem("userInfo");
    window.localStorage.removeItem("userToken");
    this.props.history.push("/login");
  };

  render() {
    return (
      <UserContext.Provider
        value={{
          userInfo: this.state.userInfo,
          userToken: this.state.userToken,
          loginUser: this.loginUser,
          registerUser: this.registerUser,
          logoutUser: this.logoutUser,
        }}
      >
        {this.props.children}
      </UserContext.Provider>
    );
  }
}

export default withRouter(UserProvider);
