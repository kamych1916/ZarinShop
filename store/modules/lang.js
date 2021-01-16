
const state = {
    language: null,
}

const mutations = {
    update__language(state, language){
        
        state.language = language

    }
}

const actions = {
    load__language({commit}, language){ 
        commit('update__language', language)
    }
}

export default {
    namespaced: true,
    actions,
    mutations,
    state
}