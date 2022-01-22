import React, { Component } from "react";
import "./CustomerCard.css";
import $ from "jquery";

class CustomerCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      increaseBalanceForm: false,
    };
  }

  increaseCustomerBalanceSubmit = async () => {
    const increaseBalance = $(".increase-amount-input-field").get(0).value;
    if (isNaN(increaseBalance)) {
      alert("Increase Balance Amount must be integer type");
      return;
    }
    if (parseInt(increaseBalance) <= 0) {
      alert("Increase Balance Amount must be positive value");
      return;
    }

    const UserToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      url: "http://localhost/employee/update/customer/balance",
      method: "POST",
      headers: { token: UserToken },
      data: {
        customerId: this.props.customer.Id,
        email: this.props.customer.Email,
        balanceChanged: increaseBalance,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    if (response.status == 200) {
      alert("Update Customer Balance Success !");
      window.location.reload();
    } else {
      alert(response.message);
    }
  };

  render() {
    const { Id, Fullname, Email, Balance } = this.props.customer;

    return (
      <div className="customer-card-wrapper">
        <div className="customer-card-item">
          <div>{Id}</div>
        </div>
        <div className="customer-card-item">
          <div>{Fullname}</div>
        </div>
        <div className="customer-card-item">
          <div>{Email}</div>
        </div>
        <div className="customer-card-item">
          <div>{Balance}</div>
        </div>
        {!this.state.increaseBalanceForm && (
          <div className="customer-card-item">
            <button
              className="styled-btn"
              onClick={() => this.setState({ increaseBalanceForm: true })}
            >
              Update Customer Balance
            </button>
          </div>
        )}
        {this.state.increaseBalanceForm && (
          <div className="customer-card-item increase-balance-form-wrapper">
            <input
              type="text"
              className="increase-amount-input-field"
              placeholder="Increase Amount"
            />
            <button
              className="smaller-styled-btn"
              onClick={() => {
                this.increaseCustomerBalanceSubmit();
              }}
            >
              Submit
            </button>
          </div>
        )}
      </div>
    );
  }
}

export default CustomerCard;
