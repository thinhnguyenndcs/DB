import React, { Component } from "react";
import Form from "../common/form";
import "./AccessoriesTypeForm.css";
import JoiBase from "joi";
import JoiDate from "@hapi/joi-date";
import $ from "jquery";

const Joi = JoiBase.extend(JoiDate); // extend Joi with Joi Date

class AccessoriesTypeForm extends Form {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        name: "",
        functionType: "",
        manufactureId: "",
      },
      errors: {},
      manufactures: [],
      message: "",
    };
  }

  componentDidMount = async () => {
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/manufactures`,
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    console.log(response);
    if (response.status == 200) {
      const manufactures = response.response;
      this.setState({ manufactures });
    }
  };

  schema = Joi.object({
    name: Joi.string().required().label("Product Name"),
    functionType: Joi.string().required().label("Function Type"),
    manufactureId: Joi.number().integer().min(1).label("Manufacturer"),
  });

  doSubmit = async () => {
    const UserToken = JSON.parse(window.localStorage.getItem("userToken"));

    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/item/insert/accessories/type`,
      data: {
        name: this.state.data.name,
        functionType: this.state.data.functionType,
        manufactureId: this.state.data.manufactureId,
      },
      headers: {
        token: UserToken,
      },
    };

    let response = await $.ajax(settings);

    response = JSON.parse(response);

    console.log("New Type:", response);

    if (response.status == 200) {
      this.props.history.push("/types");
    } else {
      alert("Add Type Failed");
    }
  };

  render() {
    return (
      <div className="form-wrapper">
        <div className="error-message">{this.state.message}</div>
        <h1 className="form-title"> New Accessories Type Form </h1>
        <form className="form-body" onSubmit={this.handleSumbit}>
          {" "}
          {this.renderInput("name", "Product Type Name")}{" "}
          {this.renderInput("functionType", "Function Type")}{" "}
          {this.renderSelect("manufactureId", "", this.state.manufactures)}
          {/* Since this.validateProperty has setState({}), every time some input in form changed, the form rerender, this.validate() fires to return updated value */}{" "}
          {this.renderButton("Register")}{" "}
        </form>{" "}
      </div>
    );
  }
}

export default AccessoriesTypeForm;
