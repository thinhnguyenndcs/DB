import React, { Component } from "react";
import Form from "../common/form";
import "./FilterItemForm.css";
import JoiBase from "joi";
import JoiDate from "@hapi/joi-date";

const Joi = JoiBase.extend(JoiDate); // extend Joi with Joi Date

class FilterItemForm extends Form {
  constructor(props) {
    super(props);
    this.state = {
      data: { searchString: "" },
      errors: {},
      message: "",
    };
  }

  schema = Joi.object({
    searchString: Joi.string().required().label("Search String"),
  });

  doSubmit = async () => {
    console.log("Filter Item Search String", this.state.data.searchString);
    await this.props.onSearchSubmit(this.state.data.searchString);
  };

  render() {
    const { onSearchSubmit } = this.props;
    return (
      <div className="form-wrapper">
        <div className="error-message">{this.state.message}</div>
        <h1 className="form-title"> Filter Item By Name </h1>{" "}
        <form className="form-body" onSubmit={this.handleSumbit}>
          {this.renderInput("searchString", "Search String")}
          {/* Since this.validateProperty has setState({}), every time some input in form changed, the form rerender, this.validate() fires to return updated value */}
          {this.renderButton("Search")}
        </form>
      </div>
    );
  }
}

export default FilterItemForm;
