import axios from "axios";

axios.defaults.baseURL = 'http://13.49.18.134/api'

axios.interceptors.response.use(resp=> resp, async error => {
    if(error.response.status === 401){
        const response = await axios.post('refresh', {}, {withCredentials:true})
        
        if(response.status === 200){
            axios.defaults.headers.common['Authorization'] = `Bearer ${response.data['access']}`

            return axios(error.config);
        }
    }

    return error;
});