import React, { Component } from "react";
import "./ItemCard.css";
import Manufactures from "../pages/Manufactures";

class ItemCard extends React.Component {
  render() {
    const {
      ItemType,
      IndexId,
      Name,
      FunctionType,
      Manufacturer,
      SalePrice,
      OrderId,
    } = this.props.item;

    return (
      <div className="item-card-wrapper">
        <div className="item-card-item">
          <div>{ItemType}</div>
        </div>
        <div className="item-card-item">
          <div>{IndexId}</div>
        </div>
        <div className="item-card-item">
          <div>{Name}</div>
        </div>
        <div className="item-card-item">
          <div>{FunctionType}</div>
        </div>
        <div className="item-card-item">
          <div>{Manufacturer}</div>
        </div>
        <div className="item-card-item">
          <div>{SalePrice}</div>
        </div>
        <div className="item-card-item">
          <div>{OrderId ? OrderId : "Not Bought Yet"}</div>
        </div>
        <div className="item-card-item">
          <button className="styled-btn">Delete</button>
        </div>
      </div>
    );
  }
}

export default ItemCard;
