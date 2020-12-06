
import axios from "axios";
// const API_BASE_URL = 'http://mirllex.site:8000/api/v1';
const API_BASE_URL = 'https://mirllex.site/server/api/v1';

export default class Api {
    instance = null;


    static getInstance() {
        if (Api.instance == null) {
            Api.instance = new Api; 
        }
        return Api.instance;
    }

    products ={
        async getDataProducts() {
            return axios.get(`${API_BASE_URL}/items`, 
                {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('st')}`
                    }  
                } 
            )
        },
        async getCategories() {
            return axios.get(`${API_BASE_URL}/list_categories`, 
                {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('st')}`
                    }  
                } 
            )
        },
        async deleteFile(name) {
            return axios.post(`${API_BASE_URL}/del_file`, {name} ,
                {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('st')}`
                    }  
                } 
            )
        },
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
                    password
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
            return axios.get(`${API_BASE_URL}/is_admin`, 
                {
                    headers: {
                        Authorization: `Bearer ${localStorage.getItem('st')}`
                    }  
                }
            )
        },

        async send_new_category(category) {
            return axios.post(`${API_BASE_URL}/categories`, category)
        },
        async upload_file(formData) {
            console.log('API_BASE_URL-> ', API_BASE_URL)
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
