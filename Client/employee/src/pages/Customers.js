import React, { Component } from "react";
import $ from "jquery";
import CustomerCard from "../components/CustomerCard";
import "./Customers.css";

class Customers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      customers: [],
    };
  }

  componentDidMount = async () => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/employee/all/customer`,
      headers: {
        token: userToken,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    console.log(response);
    if (response.status == 200) {
      const customers = response.response;
      this.setState({ customers });
    } else {
      alert("Error");
    }
  };
  render() {
    return (
      <div>
        <h1>Customers</h1>
        <div className="customers-wrapper">
          {this.state.customers.map((customer) => (
            <CustomerCard
              history={this.props.history}
              key={customer.Email}
              customer={customer}
            />
          ))}
        </div>
      </div>
    );
  }
}

export default Customers;
