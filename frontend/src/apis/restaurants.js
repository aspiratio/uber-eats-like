import axios from "axios";
import { restaurantsIndex } from "../urls";

export const fetchRestaurants = () => {
  return axios
    .get(restaurantsIndex)
    .then((res) => {
      return res.data;
    })
    .catch((e) => console.error(e));
};
