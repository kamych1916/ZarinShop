
import axios from "axios";
import { get } from "http";
const API_BASE_URL = 'http://zarinshop.site:49354/api/v1';

export default class Api {
    instance = null

    static getInstance() {
        if (Api.instance == null) {
            Api.instance = new Api; 
        }
        return Api.instance;
    }

    auth = {
        async register(first_name, last_name, email, password) {
            return axios.post(
                `${API_BASE_URL}/signup`,
                {
                    first_name,
                    last_name,
                    email,
                    password,
                }
                
            )
        },
        
        async login(email, password) {
            return axios.post(
                `${API_BASE_URL}/signin`,
                {
                    email,
                    password,
                }
                
            )
        },
        async logout() {
            return axios.get( `${API_BASE_URL}/auth/sign_out` )
        },
        async forgot_password(email) {
            return axios.get(`${API_BASE_URL}/reset_password/?email=${email}`)
        },        
        async reset_password(code, password, email) {
            return axios.post(`${API_BASE_URL}/change_password?code=${code}&new_password=${password}&email=${email}`)
        },
        
    }
    



}
