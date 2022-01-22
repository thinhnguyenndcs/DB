import React, { Component } from "react";
import Form from "../common/form";
import "./LoginForm.css";
import JoiBase from "joi";
import JoiDate from "@hapi/joi-date";
import Axios from "axios";

const Joi = JoiBase.extend(JoiDate); // extend Joi with Joi Date

class LoginForm extends Form {
  constructor(props) {
    super(props);
    this.state = {
      data: { email: "", password: "" },
      errors: {},
      message: "",
    };
  }

  schema = Joi.object({
    email: Joi.string()
      .required()
      .email({ tlds: { allow: false } })
      .label("Email"),
    password: Joi.string().required().min(5).label("Password"),
  });

  doSubmit = async () => {
    const response = await this.props.onUserLogin(this.state.data);
    if (response.status != 200) {
      this.setState({ message: response.message });
    }
  };

  render() {
    return (
      <div className="form-wrapper">
        <div className="error-message">{this.state.message}</div>
        <h1 className="form-title"> Employee Login Page </h1>{" "}
        <form className="form-body" onSubmit={this.handleSumbit}>
          {this.renderInput("email", "Email")}
          {this.renderInput("password", "Password", "password")}
          {/* Since this.validateProperty has setState({}), every time some input in form changed, the form rerender, this.validate() fires to return updated value */}
          {this.renderButton("Login")}
        </form>
      </div>
    );
  }
}

export default LoginForm;
