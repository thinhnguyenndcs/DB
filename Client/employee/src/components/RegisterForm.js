import React, { Component } from "react";
import Form from "../common/form";
import "./RegisterForm.css";
import JoiBase from "joi";
import JoiDate from "@hapi/joi-date";
import $ from "jquery";

const Joi = JoiBase.extend(JoiDate); // extend Joi with Joi Date

class RegisterForm extends Form {
  constructor(props) {
    super(props);
    this.state = {
      data: { fullname: "", email: "", password: "", salary: "", branchId: "" },
      errors: {},
      branches: [],
      message: "",
    };
  }

  componentDidMount = async () => {
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/branches`,
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    if (response.status == 200) {
      const branches = response.response;
      this.setState({ branches });
    } else {
      alert("Get branches info from server failed");
    }
  };

  schema = Joi.object({
    email: Joi.string()
      .required()
      .email({ tlds: { allow: false } })
      .label("Email"),
    fullname: Joi.string().required().label("Username"),
    password: Joi.string().required().min(5).label("Password"),
    salary: Joi.number()
      .integer()
      .required()
      .min(10000)
      .max(500000)
      .label("Salary"),
    branchId: Joi.number().integer().required().min(1).label("Branch"),
  });

  doSubmit = async () => {
    const response = await this.props.onUserRegister(this.state.data);
    if (response.status == 200) {
      alert("Register Success, Please Login");
      this.props.history.push("/login");
    } else {
      alert("Register failed");
      this.setState({ message: response.message });
    }
  };

  render() {
    const { onUserRegister } = this.props;

    return (
      <div className="form-wrapper">
        <div className="error-message">{this.state.message}</div>
        <h1 className="form-title"> Employee Register Page </h1>
        <form className="form-body" onSubmit={this.handleSumbit}>
          {" "}
          {this.renderInput("email", "Email")}{" "}
          {this.renderInput("fullname", "Full Name")}{" "}
          {this.renderInput("password", "Password", "password")}{" "}
          {this.renderInput("salary", "Salary")}
          {this.renderSelect("branchId", "", this.state.branches)}
          {/* Since this.validateProperty has setState({}), every time some input in form changed, the form rerender, this.validate() fires to return updated value */}{" "}
          {this.renderButton("Register")}{" "}
        </form>{" "}
      </div>
    );
  }
}

export default RegisterForm;
