
import axios from "axios";
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
        async register(first_name, last_name, email, password, phone) {
            return axios.post(
                `${API_BASE_URL}/signup`,
                {
                    first_name,
                    last_name,
                    email,
                    password,
                    phone,
                }
                
            )
        },
        async send_activate_code(code, email) {
            return axios.get(`${API_BASE_URL}/checkcode_activ?code=${code}&email=${email}`)
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
            return axios.delete(`${API_BASE_URL}/logout`)
        },
        async forgot_password(email) {
            return axios.get(`${API_BASE_URL}/reset_password/?email=${email}`)
        },        
        async reset_password(code, password, email) {
            return axios.post(`${API_BASE_URL}/change_password?code=${code}&new_password=${password}&email=${email}`)
        },

        async check_is_admin() {
            return axios.get(`${API_BASE_URL}/is_admin`)
        },

        async send_new_category(category) {
            return axios.post(`${API_BASE_URL}/categories`, category)
        },
        async upload_file(formData) {
            console.log(formData)
            return axios.post(`${API_BASE_URL}/uploadfile`, formData, 
            {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }
           )
        },
        
        
        
    }
    



}
