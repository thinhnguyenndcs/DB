import React, { Component } from "react";
import RegisterForm from "../components/RegisterForm";
import { UserContext } from "../contexts/UserContext";

class Register extends React.Component {
  state = {};

  render() {
    return (
      <div className="register-page-wrapper">
        <UserContext.Consumer>
          {({ registerUser }) => {
            return (
              <RegisterForm
                history={this.props.history}
                onUserRegister={registerUser}
              />
            );
          }}
        </UserContext.Consumer>
      </div>
    );
  }
}

export default Register;
