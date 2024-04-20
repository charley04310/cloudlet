use crate::client::VmmClient;
use actix_web::{get, post, web, HttpResponse, Responder};

#[post("/configuration")]
pub async fn configuration(req_body: String) -> impl Responder {
    // TODO: Use the body to create the vm configuration
    HttpResponse::Ok().body(req_body)
}

#[post("/run")]
pub async fn run(req_body: String) -> impl Responder {
    let grpc_client = VmmClient::new().await;

    match grpc_client {
        Ok(mut client) => {
            client.run_vmm().await;
            HttpResponse::Ok().body(req_body)
        }
        Err(e) => HttpResponse::InternalServerError()
            .body("Failed to connect to VMM service with error: ".to_string() + &e.to_string()),
    }
    
}

#[get("/logs/{id}")]
pub async fn logs(id: web::Path<String>) -> HttpResponse {
    // TODO: maybe not close the stream and keep sending the logs
    HttpResponse::Ok().body(format!("Logs here: {}", &id))
}

#[get("/metrics/{id}")]
pub async fn metrics(id: web::Path<String>) -> HttpResponse {
    // TODO: Get the metrics for a VM with the given ID

    HttpResponse::Ok().body(format!("Metrics here: {}", &id))
}

#[post("/shutdown")]
pub async fn shutdown(req_body: String) -> impl Responder {
    // TODO: Get the id from the body and shutdown the vm
    HttpResponse::Ok().body(req_body)
}
