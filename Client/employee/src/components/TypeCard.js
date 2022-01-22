import React, { Component } from "react";
import "./TypeCard.css";
import $ from "jquery";

class TypeCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      addItemForm: false,
    };
  }

  addItemQuantity = async () => {
    const quantity = $(".quantity-input-field").get(0).value;
    const salePrice = $(".saleprice-input-field").get(0).value;
    const importPrice = $(".importprice-input-field").get(0).value;
    const branchId = $(".branchid-input-field").get(0).value;

    if (isNaN(quantity) || isNaN(salePrice) || isNaN(importPrice)) {
      alert("Quantity, Saleprice, Importprice must be integer value");
      return;
    }

    if (parseInt(importPrice) >= parseInt(salePrice)) {
      alert("Saleprice must be higher tham Importprice");
      return;
    }

    const UserToken = JSON.parse(window.localStorage.getItem("userToken"));

    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/item/insert`,
      data: {
        itemType: this.props.type.ItemType,
        typeId: this.props.type.TypeId,
        salePrice: salePrice,
        importPrice: importPrice,
        branchId: branchId,
        quantity: quantity,
      },
      headers: {
        token: UserToken,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    if (response.status == 200) {
      alert("Item add success");
      window.location.reload();
    } else {
      alert(response.message);
    }
  };

  render() {
    const {
      ItemType,
      TypeId,
      Name,
      FunctionType,
      Manufacturer,
      TotalNumber,
      LeftNumber,
    } = this.props.type;

    const { branches } = this.props;

    return (
      <div className="type-card-wrapper">
        <div className="type-card-item">
          <div>{ItemType}</div>
        </div>
        <div className="type-card-item">
          <div>{TypeId}</div>
        </div>
        <div className="type-card-item">
          <div>{Name}</div>
        </div>
        <div className="type-card-item">
          <div>{FunctionType}</div>
        </div>
        <div className="type-card-item">
          <div>{Manufacturer}</div>
        </div>
        <div className="type-card-item">
          <div>{TotalNumber}</div>
        </div>
        <div className="type-card-item">
          <div>{LeftNumber}</div>
        </div>
        <div className="type-card-item">
          {!this.state.addItemForm && (
            <button
              className="styled-btn"
              onClick={() => {
                this.setState({ addItemForm: true });
              }}
            >
              Add More Item
            </button>
          )}
          {this.state.addItemForm && (
            <div>
              <input
                className="quantity-input-field"
                placeholder="Quantity"
              ></input>
              <input
                className="saleprice-input-field"
                placeholder="Sale Price"
              ></input>
              <input
                className="importprice-input-field"
                placeholder="Import Price"
              ></input>
              <select className="branchid-input-field" placeholder="Branch Id">
                {branches.map((branch) => (
                  <option key={branch.Id} value={branch.Id}>
                    {branch.Name}
                  </option>
                ))}
              </select>
              <button
                className="smaller-styled-btn"
                onClick={() => {
                  this.addItemQuantity();
                }}
              >
                Submit
              </button>
            </div>
          )}
        </div>
      </div>
    );
  }
}

export default TypeCard;
