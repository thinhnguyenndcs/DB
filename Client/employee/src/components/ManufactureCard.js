import React, { Component } from "react";
import "./ManufactureCard.css";

class ManufactureCard extends React.Component {
  render() {
    const { Id, Name, Country } = this.props.manufacture;

    return (
      <div className="manufacture-card-wrapper">
        <div className="manufacture-card-item">
          <div>{Id}</div>
        </div>
        <div className="manufacture-card-item">
          <div>{Name}</div>
        </div>
        <div className="manufacture-card-item">
          <div>{Country}</div>
        </div>
        <div className="manufacture-card-item">
          <button className="styled-btn">Delete</button>
        </div>
      </div>
    );
  }
}

export default ManufactureCard;
