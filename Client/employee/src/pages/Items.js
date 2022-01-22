import React, { Component } from "react";
import $ from "jquery";
import "./Items.css";
import ItemCard from "../components/ItemCard";
import FilterItemForm from "../components/FilterItemForm";

class Items extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      items: [],
    };
  }

  componentDidMount = async () => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/items`,
      headers: {
        token: userToken,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    console.log(response);
    if (response.status == 200) {
      const items = response.response;
      this.setState({ items });
    } else {
      alert("Please login as Employee");
    }
  };

  handleFilterItem = async (searchString) => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      method: "POST",
      timeout: 0,
      url: `http://localhost/item/search`,
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
      const items = response.response;
      this.setState({ items });
    } else {
      alert("Please login as Employee");
    }
  };

  render() {
    return (
      <div>
        <h1>Items Page</h1>
        <FilterItemForm onSearchSubmit={this.handleFilterItem} />
        <div className="items-wrapper">
          {this.state.items.map((item) => (
            <ItemCard key={item.IndexId + item.ItemType} item={item} />
          ))}
        </div>
      </div>
    );
  }
}

export default Items;
