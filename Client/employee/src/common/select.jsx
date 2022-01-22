import React, { Component } from "react";
import "./select.css";

const Select = (props) => {
  const { name, label, options, error, ...rest } = props;
  return (
    <div className="form-group">
      <label htmlFor={name}>{label}</label>
      <select name={name} id={name} {...rest} className="options">
        <option>Please select</option>
        {options.map((option) => (
          <option key={option.Id} value={option.Id}>
            {option.name || option.Name}
          </option>
        ))}
      </select>
      {error && <div className="alert alert-danger">{error}</div>}
    </div>
  );
};

export default Select;
