<template>
    <v-container>
        <v-row>
            <SlotComponent ref="any"
            ></SlotComponent>
            <SlotComponent ref="text"
            ></SlotComponent>
            <SlotComponent ref="bool"
            ></SlotComponent>
            <SlotComponent ref="categorical"
            ></SlotComponent>
            <SlotComponent ref="float"
            ></SlotComponent>
            <SlotComponent ref="list"
            ></SlotComponent>
            <SlotComponent ref="unfeaturized"
            ></SlotComponent>
        </v-row>
    </v-container>
</template>

<script>

import axios from 'axios'
import SlotComponent from "./slot.vue"

export default {
    components: {
        SlotComponent
    },
    data: () => ({
    }),

    created () {
      this.initialize()
    },

    methods: {
        initialize(){
            
            var that = this; 
            const headers = {"Access-Control-Allow-Origin": "*"};

            axios.get(`http://51.91.10.250:11000/slots/all`, 
                {headers}
            
                ).then(function(response){
                    that.$refs.any.initialize("any", response['data']["slots"]['any']);
                    that.$refs.text.initialize("text", response['data']["slots"]['text']);
                    that.$refs.bool.initialize("bool", response['data']["slots"]['bool']);
                    that.$refs.categorical.initialize("categorical", response['data']["slots"]['categorical']);
                    that.$refs.float.initialize("float", response['data']["slots"]['float']);
                    that.$refs.list.initialize("list", response['data']["slots"]['list']);
                    that.$refs.unfeaturized.initialize("unfeaturized", response['data']["slots"]['unfeaturized']);
                })
            
        }
    }
}
</script>
