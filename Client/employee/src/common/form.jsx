import React, { Component } from "react";
// import Joi from "joi";
import Input from "./input";
import Select from "./select";
import Textarea from "./textarea";

class Form extends React.Component {
  //
  //   Controlled element: same as controlled components
  //   Must get rid of the DOM input default state, make
  //   the input field using the same state that the page
  //   Login Form contains

  //   React has strict rule about what DOM/React is controlled components or not
  //   Must set below values as empty to clear the field, passing undefined to an HTML element
  //   value suddenly makes the element become uncontrolled

  state = {
    data: {},
    errors: {},
  };

  validate = () => {
    const options = { abortEarly: false };
    const result = this.schema.validate(this.state.data, options);
    const { error } = result;
    if (!error) return null;
    const errors = {};
    for (let item of error.details) {
      errors[item.path[0]] = item.message;
    }
    return errors;
  };

  // Fire when input field has value change, passed in the target input field to get name, value to validate
  validateProperty = (input) => {
    // Computed properties [run-time var] in ES6
    // const obj = { [input.name]: input.value };
    // console.log(obj);
    // const subSchema = this.schema.extract(input.name);
    // console.log(subSchema);
    // const result = subSchema.validate(obj);
    // console.log("field result", result);
    // const { error } = result;
    // return error ? error.details[0].message : null;
  };

  // Fire when form is submit
  handleSumbit = (evt) => {
    evt.preventDefault();
    const errors = this.validate();
    this.setState({ errors: errors || {} });
    if (errors) return;

    this.doSubmit();
  };

  handleChange = (evt) => {
    const input = evt.currentTarget;
    const errors = { ...this.state.errors };
    const errorMessage = this.validateProperty(input);

    if (errorMessage) {
      errors[input.name] = errorMessage;
    } else {
      delete errors[input.name];
    }

    const data = { ...this.state.data };
    data[evt.currentTarget.name] = evt.currentTarget.value;
    this.setState({ data: data, errors });
  };

  renderButton(label) {
    return (
      <button disabled={false} className="btn-confirm">
        {label}
      </button>
    );
  }

  renderInput(name, label, type = "text") {
    const { data, errors } = this.state;

    return (
      <Input
        type={type}
        name={name}
        error={errors[name]}
        value={data[name]}
        label={label}
        onChange={this.handleChange}
      />
    );
  }

  // renderTextarea(name, label, type = "") {
  //   const { data, errors } = this.state;

  //   return (
  //     <Textarea
  //       type={type}
  //       name={name}
  //       error={errors[name]}
  //       value={data[name]}
  //       label={label}
  //       onChange={this.handleChange}
  //     />
  //   );
  // }

  renderSelect(name, label, options) {
    const { data, errors } = this.state;

    return (
      <Select
        name={name}
        value={data[name]}
        label={label}
        options={options}
        onChange={this.handleChange}
        error={errors[name]}
      />
    );
  }
}

export default Form;
