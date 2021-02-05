<template>
    <v-col>
        <v-row>
            <v-col
                cols="1"
                md="10"
            >
                <v-sheet
                elevation="12"
                class="px-12 py-1"
                >
                <v-text-field
                    v-model="texttobot"
                    placeholder="placeholder"
                    Regular
                    filled
                    clearable
                    flat
                    counter
                    dense
                    @keyup.enter.prevent='sendtobot'
                ></v-text-field>
                </v-sheet>
            </v-col>  
            <v-col  cols="1" md="1">
                <v-btn class="ma-2" tile color="indigo" dark v-on:click="sendtobot()">Envoyer</v-btn>
            </v-col>
        </v-row>
        <v-container>
            <v-list>
                <ChatClientResponse
                v-for="item in interactions"
                v-bind:key="item.id"
                v-bind:client="item.client"
                v-bind:message="item.message"
                v-bind:user="item.user"
                ></ChatClientResponse>
            </v-list>
        </v-container>
    </v-col>
</template>

<script>
const axios = require("axios");

import ChatClientResponse from "./chatclientresponse.vue"

export default {
    components: {
        ChatClientResponse
    },
    data: () => ({
        texttobot: "",
        interactions: []
    }),
    methods: {
        sendtobot(){
            if (this.texttobot){
                this.interactions.reverse();
                this.interactions.push({"client":true,"message":this.texttobot, "user": "mamieprout"});
                this.interactions.reverse();

                const headers = {"Content-Type": "application/json","Access-Control-Allow-Origin": "*"};
                const data = {"message": this.texttobot, "sender": "bot"}
                var that = this;

                axios.post('http://51.91.10.250:5005/webhooks/rest/webhook', data, {headers})
                    .then(function(response){
                        console.log(response);
                        that.interactions.reverse();
                        response["data"].forEach(element => {
                            that.interactions.push({"client":false, "message":element["text"], "user": element["recipient_id"]});
                        });
                        that.interactions.reverse();
                        that.texttobot = "";
                    })
                    .catch(function(err) {
                        this.interactions.reverse();
                        this.interactions.push({"client":null, "message":err});
                        this.interactions.reverse();

                    });
                }
            }
            
        }
    }
</script>