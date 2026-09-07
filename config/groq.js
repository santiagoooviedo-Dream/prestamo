//Importamos groq
import groq from 'groq';

//creamos la conexion con groq
export const groq = new  groq({
    apiKey: process.env.GROQ_API_KEY
});