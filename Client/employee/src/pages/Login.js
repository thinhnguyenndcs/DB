import React, { Component } from "react";
import LoginForm from "../components/LoginForm";
import { UserContext } from "../contexts/UserContext";

class Login extends React.Component {
  render() {
    return (
      <div className="login-page-wrapper">
        <UserContext.Consumer>
          {({ loginUser }) => {
            return (
              <LoginForm history={this.props.history} onUserLogin={loginUser} />
            );
          }}
        </UserContext.Consumer>
      </div>
    );
  }
}

export default Login;
