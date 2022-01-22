import React, { Component } from "react";
import $ from "jquery";
import TypeCard from "../components/TypeCard";
import "./Types.css";
import FilterTypeForm from "../components/FilterTypeForm";

class Types extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      types: [],
      branches: [],
    };
  }

  setUpTypes = async () => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    console.log("User Token: ", userToken);
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/types`,
      headers: {
        token: userToken,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    console.log(response);
    if (response.status == 200) {
      const types = response.response;
      this.setState({ types });
    } else {
      alert("Please login as Employee");
    }
    return 0;
  };

  setUpBranches = async () => {
    /**
     *  Get all branches for Add Item Procedure
     */
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
    }
    return 0;
  };

  componentDidMount = async () => {
    this.setUpTypes();
    this.setUpBranches();
  };

  routeToCreateTypePage = () => {
    this.props.history.push("/type/create");
  };

  handleFilterType = async (searchString) => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/type/search`,
      data: {
        searchString: searchString,
      },
      headers: {
        token: userToken,
      },
    };
    let response = await $.ajax(settings);
    response = JSON.parse(response);
    if (response.status == 200) {
      const types = response.response;
      this.setState({ types });
    } else {
      alert("Please login as Employee");
    }
  };

  render() {
    return (
      <div className="types-wrapper">
        <div>
          <h1>Types Page</h1>
        </div>
        <div>
          <button
            onClick={() => {
              this.routeToCreateTypePage();
            }}
            className="add-type-btn"
          >
            Add New Product Type
          </button>
          <button
            onClick={() => {
              this.routeToCreateTypePage();
            }}
            className="add-type-btn"
          >
            Add New Accessories Type
          </button>
        </div>
        <FilterTypeForm onSearchSubmit={this.handleFilterType} />
        {this.state.types.map((type) => (
          <TypeCard
            key={type.Name}
            type={type}
            branches={this.state.branches}
            history={this.props.history}
          />
        ))}
      </div>
    );
  }
}

export default Types;
