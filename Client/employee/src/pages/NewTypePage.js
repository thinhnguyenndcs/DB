import React, { Component } from "react";
import ProductTypeForm from "../components/ProductTypeForm";
import AccessoriesTypeForm from "../components/AccessoriesTypeForm";
import $ from "jquery";

class NewTypePage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      branches: [],
    };
  }

  componentDidMount = async () => {
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
  };

  render() {
    return (
      <div>
        <ProductTypeForm
          history={this.props.history}
          branches={this.state.branches}
        />
        <AccessoriesTypeForm
          history={this.props.history}
          branches={this.state.branches}
        />
      </div>
    );
  }
}

export default NewTypePage;
