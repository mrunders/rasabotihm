<template>
    <v-container>
        <v-row>
            <v-select
                class="col-md-4"
                ref="response_name"
                v-model="response_name"
                :rules="[() => !!response_name || 'This field is required']"
                :items="intentkeys"
                label="Nom de l'élément"
                placeholder="Select..."
                required
                v-on:change="changeIntentKey"
            >
            </v-select>
            <v-spacer></v-spacer>
            <v-btn
                class="col-md-2 my-4"
                justify="center"
                align="center"
                color="blue darken-1"
                text
                @click="newintent"
                >
                AJouter un élément
            </v-btn>
        </v-row>
        <v-dialog
            v-model="dialog"
            max-width="500px"
        >
            <v-card>
            <v-card-title>
                <span class="headline">Ajouter un élément</span>
            </v-card-title>

            <v-card-text>
                <v-container>
                <v-row>
                    <v-col
                    cols="12"
                    sm="8"
                    md="8"
                    >
                    <v-text-field
                        v-model="response_name"
                        label="Intent"
                    ></v-text-field>
                    </v-col>
                </v-row>
                </v-container>
            </v-card-text>

            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                color="blue darken-1"
                text
                @click="close"
                >
                Cancel
                </v-btn>
                <v-btn
                color="blue darken-1"
                text
                @click="save"
                >
                Save
                </v-btn>
            </v-card-actions>
            </v-card>
        </v-dialog>
        <v-row>
            <ResponseText ref="myawesometable"
                v-bind:response_name="this.response_name"
            ></ResponseText>
        </v-row>
    </v-container>
</template>

<script>

import axios from 'axios'
import ResponseText from "./responsetext.vue"

export default {
    components: {
        ResponseText
    },  
    data: () => ({
        dialog: false,
        ttype: "responses",
        response_name: "",
        intentkeys: []
    }),
    created() {
        this.initialize();
    },
    methods: {
        initialize(){
            
            const headers = {"Access-Control-Allow-Origin": "*"};
            const that = this;
            axios.get(`http://51.91.10.250:11000/responses/`, {headers}
            
            ).then(function(response){
                that.intentkeys = response["data"]["responses"]
            })
            .catch(function(err) {
                console.log(err);
            });
            
        },
        changeIntentKey(){
            this.$refs.myawesometable.initialize(this.response_name, this.initialize);
        },
        filterOnlyCapsText (value, search, item) {
            return value != null &&
                search != null &&
                typeof value === 'string' &&
                value.toString().toLocaleUpperCase().indexOf(search) !== -1
        },

        newintent(){
            this.dialog = true
        },
        close () {
            this.dialog = false;
        },
        save () {

            const that = this;
            const headers = {"Access-Control-Allow-Origin": "*"};
            axios.post(`http://51.91.10.250:11000/responses/${this.response_name}`, {headers}
            
            ).then(function(response){
                that.response_name = response["data"]["response"];
                that.intentkeys.push(that.response_name);
                that.$refs.myawesometable.initialize(that.response_name, that.initialize);
            })
            .catch(function(err) {
                console.log(err);
            });
            this.close()
        },

    }
}
</script>
