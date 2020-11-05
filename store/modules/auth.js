
const state = {
    login_access: null,
}

const mutations = {
    update__login_access(state, login_access){
        
        state.login_access = login_access

    }
}

const actions = {
    load__login_access({commit}, login_access){ 
        commit('update__login_access', login_access)
    }
}

export default {
    namespaced: true,
    actions,
    mutations,
    state
}