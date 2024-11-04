import { Handler } from "aws-lambda";
import axios from "axios";

async function hello() {
  const response = await axios.get("https://jsonplaceholder.typicode.com/posts/1");
  console.log("response.data >", JSON.stringify(response.data));
  console.log("hello world!");
}
hello();

export const handler: Handler = async () => {
  return await hello();
};
