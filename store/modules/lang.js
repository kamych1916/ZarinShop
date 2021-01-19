
const state = {
    language: null,
}

const mutations = {
    update_language(state, language){
        
        state.language = language

    }
}

const actions = {
    load_language({commit}, language){ 
        commit('update_language', language)
    }
}

export default {
    namespaced: true,
    actions,
    mutations,
    state
}