export async function get(url: string) {
    const response = await fetch(url, {
        method: "GET",
        mode: "same-origin", // If a request is made to another origin with this mode set, the result is an error. Used to ensure that a request is always being made to your origin. See https://developer.mozilla.org/en-US/docs/Web/API/Request/mode
        credentials: "same-origin", // Send user credentials (cookies, basic http auth, etc..) if the URL is on the same origin as the calling script. This is the default value. See https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials
        referrerPolicy: "no-referrer", // The Referer header will be omitted: sent requests do not include any referrer information. See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy
        cache: "no-store", // The browser fetches the resource from the remote server without first looking in the cache, and will not update the cache with the downloaded resource. See https://developer.mozilla.org/en-US/docs/Web/API/Request/cache
    });
    return response.json();
}
