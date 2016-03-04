// Copyright 2011 Google Inc. All Rights Reserved.
(function() {
    var h, l = this,
        n = function(a) {
            return void 0 !== a
        },
        r = function(a, b, c) {
            a = a.split(".");
            c = c || l;
            a[0] in c || !c.execScript || c.execScript("var " + a[0]);
            for (var d; a.length && (d = a.shift());)!a.length && n(b) ? c[d] = b : c[d] ? c = c[d] : c = c[d] = {}
        },
        aa = function(a, b) {
            for (var c = a.split("."), d = b || l, e; e = c.shift();)
                if (null != d[e]) d = d[e];
                else return null;
            return d
        },
        ba = function() {},
        ca = function(a) {
            var b = typeof a;
            if ("object" == b)
                if (a) {
                    if (a instanceof Array) return "array";
                    if (a instanceof Object) return b;
                    var c = Object.prototype.toString.call(a);
                    if ("[object Window]" == c) return "object";
                    if ("[object Array]" == c || "number" == typeof a.length && "undefined" != typeof a.splice && "undefined" != typeof a.propertyIsEnumerable && !a.propertyIsEnumerable("splice")) return "array";
                    if ("[object Function]" == c || "undefined" != typeof a.call && "undefined" != typeof a.propertyIsEnumerable && !a.propertyIsEnumerable("call")) return "function"
                } else return "null";
            else if ("function" == b && "undefined" == typeof a.call) return "object";
            return b
        },
        v = function(a) {
            return "array" == ca(a)
        },
        da = function(a) {
            var b =
                ca(a);
            return "array" == b || "object" == b && "number" == typeof a.length
        },
        w = function(a) {
            return "string" == typeof a
        },
        x = function(a) {
            return "number" == typeof a
        },
        y = function(a) {
            return "function" == ca(a)
        },
        ea = function(a) {
            var b = typeof a;
            return "object" == b && null != a || "function" == b
        },
        fa = function(a, b, c) {
            return a.call.apply(a.bind, arguments)
        },
        ga = function(a, b, c) {
            if (!a) throw Error();
            if (2 < arguments.length) {
                var d = Array.prototype.slice.call(arguments, 2);
                return function() {
                    var c = Array.prototype.slice.call(arguments);
                    Array.prototype.unshift.apply(c,
                        d);
                    return a.apply(b, c)
                }
            }
            return function() {
                return a.apply(b, arguments)
            }
        },
        z = function(a, b, c) {
            z = Function.prototype.bind && -1 != Function.prototype.bind.toString().indexOf("native code") ? fa : ga;
            return z.apply(null, arguments)
        },
        ha = function(a, b) {
            var c = Array.prototype.slice.call(arguments, 1);
            return function() {
                var b = c.slice();
                b.push.apply(b, arguments);
                return a.apply(this, b)
            }
        },
        ia = Date.now || function() {
            return +new Date
        },
        A = function(a, b) {
            function c() {}
            c.prototype = b.prototype;
            a.X = b.prototype;
            a.prototype = new c;
            a.Sf = function(a,
                c, f) {
                for (var g = Array(arguments.length - 2), k = 2; k < arguments.length; k++) g[k - 2] = arguments[k];
                return b.prototype[c].apply(a, g)
            }
        };
    Function.prototype.bind = Function.prototype.bind || function(a, b) {
        if (1 < arguments.length) {
            var c = Array.prototype.slice.call(arguments, 1);
            c.unshift(this, a);
            return z.apply(null, c)
        }
        return z(this, a)
    };
    var ja;
    var ka = function(a) {
            return /^[\s\xa0]*$/.test(a)
        },
        la = String.prototype.trim ? function(a) {
            return a.trim()
        } : function(a) {
            return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g, "")
        },
        ta = function(a) {
            if (!ma.test(a)) return a; - 1 != a.indexOf("&") && (a = a.replace(na, "&amp;")); - 1 != a.indexOf("<") && (a = a.replace(oa, "&lt;")); - 1 != a.indexOf(">") && (a = a.replace(pa, "&gt;")); - 1 != a.indexOf('"') && (a = a.replace(qa, "&quot;")); - 1 != a.indexOf("'") && (a = a.replace(ra, "&#39;")); - 1 != a.indexOf("\x00") && (a = a.replace(sa, "&#0;"));
            return a
        },
        na = /&/g,
        oa = /</g,
        pa = />/g,
        qa = /"/g,
        ra = /'/g,
        sa = /\x00/g,
        ma = /[\x00&<>"']/,
        ua = function(a, b) {
            a.length > b && (a = a.substring(0, b - 3) + "...");
            return a
        },
        B = function(a, b) {
            return -1 != a.toLowerCase().indexOf(b.toLowerCase())
        },
        va = function(a) {
            return null == a ? "" : String(a)
        },
        xa = function(a, b) {
            for (var c = 0, d = la(String(a)).split("."), e = la(String(b)).split("."), f = Math.max(d.length, e.length), g = 0; 0 == c && g < f; g++) {
                var k = d[g] || "",
                    m = e[g] || "",
                    p = RegExp("(\\d*)(\\D*)", "g"),
                    t = RegExp("(\\d*)(\\D*)", "g");
                do {
                    var D = p.exec(k) || ["", "", ""],
                        q = t.exec(m) || ["", "", ""];
                    if (0 == D[0].length && 0 == q[0].length) break;
                    c = wa(0 == D[1].length ? 0 : parseInt(D[1], 10), 0 == q[1].length ? 0 : parseInt(q[1], 10)) || wa(0 == D[2].length, 0 == q[2].length) || wa(D[2], q[2])
                } while (0 == c)
            }
            return c
        },
        wa = function(a, b) {
            return a < b ? -1 : a > b ? 1 : 0
        },
        ya = 2147483648 * Math.random() | 0,
        za = function() {
            return "display".replace(/\-([a-z])/g, function(a, b) {
                return b.toUpperCase()
            })
        },
        Aa = function(a) {
            var b = w(void 0) ? "undefined".replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g, "\\$1").replace(/\x08/g, "\\x08") : "\\s";
            return a.replace(new RegExp("(^" +
                (b ? "|[" + b + "]+" : "") + ")([a-z])", "g"), function(a, b, e) {
                return b + e.toUpperCase()
            })
        };
    var Ba = function(a) {
        Ba[" "](a);
        return a
    };
    Ba[" "] = ba;
    var Ca = function(a, b) {
        try {
            return Ba(a[b]), !0
        } catch (c) {}
        return !1
    };
    var Da = function(a) {
            try {
                return !!a && null != a.location.href && Ca(a, "foo")
            } catch (b) {
                return !1
            }
        },
        Ea = function() {
            var a = [1, 2, 3, 4];
            if (!(1E-4 > Math.random())) {
                var b = Math.random();
                if (0 > b) {
                    try {
                        var c = new Uint16Array(1);
                        window.crypto.getRandomValues(c);
                        b = c[0] / 65536
                    } catch (d) {
                        b = Math.random()
                    }
                    return a[Math.floor(b * a.length)]
                }
            }
            return null
        },
        Fa = /https?:\/\/[^\/]+/;
    var Ga = document,
        C = window;
    var Ha = function(a) {
            var b = a.toString();
            a.name && -1 == b.indexOf(a.name) && (b += ": " + a.name);
            a.message && -1 == b.indexOf(a.message) && (b += ": " + a.message);
            if (a.stack) {
                a = a.stack;
                var c = b;
                try {
                    -1 == a.indexOf(c) && (a = c + "\n" + a);
                    for (var d; a != d;) d = a, a = a.replace(/((https?:\/..*\/)[^\/:]*:\d+(?:.|\n)*)\2/, "$1");
                    b = a.replace(/\n */g, "\n")
                } catch (e) {
                    b = c
                }
            }
            return b
        },
        Ia = function(a) {
            C.google_image_requests || (C.google_image_requests = []);
            var b = C.document.createElement("img");
            b.src = a;
            C.google_image_requests.push(b)
        };
    var Ja = function(a, b) {
            for (var c in a) Object.prototype.hasOwnProperty.call(a, c) && b.call(null, a[c], c, a)
        },
        Ma = function(a) {
            var b = Ka;
            return a && a && ("object" == typeof a || "function" == typeof a) ? !La(a, b.prototype) : !0
        },
        La = function(a, b) {
            if (!a) return !1;
            var c = !0;
            Ja(b, function(b, e) {
                c && e in a && typeof b == typeof a[e] || (c = !1)
            });
            return c
        };

    function Na(a) {
        return "function" == typeof encodeURIComponent ? encodeURIComponent(a) : escape(a)
    };
    var Oa = !!window.b,
        Pa = Oa && window.parent || window,
        Qa = function() {
            if (Oa && !Da(Pa)) {
                for (var a = "." + Ga.domain; 2 < a.split(".").length && !Da(Pa);) Ga.domain = a = a.substr(a.indexOf(".") + 1), Pa = window.parent;
                Da(Pa) || (Pa = window)
            }
            return Pa
        };
    var Ka = function(a) {
            this.g = [];
            this.b = {};
            for (var b = 0, c = arguments.length; b < c; ++b) this.b[arguments[b]] = ""
        },
        Va = function(a) {
            var b;
            if (Ra()) b = Sa;
            else {
                b = Ta();
                var c = new Ka(2, 1, 3, 4, 5, 7, 10, 12, 13, 14, 17, 19, 20, 29, 31, 32, 33, 35, 36, 37, 38, 39);
                b = Sa = b.S[Ua(3)] = c
            }
            return b.b.hasOwnProperty(a) ? b.b[a] : ""
        };
    var Wa = !0,
        Xa = {},
        $a = function(a, b, c, d) {
            var e = Ya,
                f, g = Wa;
            try {
                f = b()
            } catch (k) {
                try {
                    var m = Ha(k);
                    b = "";
                    k.fileName && (b = k.fileName);
                    var p = -1;
                    k.lineNumber && (p = k.lineNumber);
                    g = e(a, m, b, p, c)
                } catch (t) {
                    try {
                        var D = Ha(t);
                        a = "";
                        t.fileName && (a = t.fileName);
                        c = -1;
                        t.lineNumber && (c = t.lineNumber);
                        Ya("pAR", D, a, c, void 0, void 0)
                    } catch (q) {
                        Za({
                            context: "mRE",
                            msg: q.toString() + "\n" + (q.stack || "")
                        }, void 0)
                    }
                }
                if (!g) throw k;
            } finally {
                if (d) try {
                    d()
                } catch (fb) {}
            }
            return f
        },
        Ya = function(a, b, c, d, e, f) {
            var g = {};
            if (e) try {
                e(g)
            } catch (k) {}
            g.context = a;
            g.msg =
                b.substring(0, 512);
            c && (g.file = c);
            0 < d && (g.line = d.toString());
            g.url = Ga.URL.substring(0, 512);
            g.ref = Ga.referrer.substring(0, 512);
            ab(g);
            Za(g, f);
            return Wa
        },
        Za = function(a, b) {
            try {
                if (Math.random() < (b || .01)) {
                    var c = "/pagead/gen_204?id=jserror" + bb(a),
                        d = "http" + ("http:" == C.location.protocol ? "" : "s") + "://pagead2.googlesyndication.com" + c,
                        d = d.substring(0, 2E3);
                    Ia(d)
                }
            } catch (e) {}
        },
        ab = function(a) {
            var b = a || {};
            Ja(Xa, function(a, d) {
                b[d] = C[a]
            })
        },
        cb = function(a, b, c, d, e) {
            return function() {
                var f = arguments;
                return $a(a, function() {
                    return b.apply(c,
                        f)
                }, d, e)
            }
        },
        db = function(a, b) {
            return cb(a, b, void 0, void 0, void 0)
        },
        bb = function(a) {
            var b = "";
            Ja(a, function(a, d) {
                if (0 === a || a) b += "&" + d + "=" + Na(a)
            });
            return b
        };
    var eb = function(a) {
        for (var b = 0, c = a, d = 0; a && a != a.parent;) a = a.parent, d++, Da(a) && (c = a, b = d);
        return {
            Za: c,
            level: b
        }
    };
    var hb = function(a) {
            this.S = a;
            gb(this, 3, null);
            gb(this, 4, 0);
            gb(this, 5, 0);
            gb(this, 6, 0);
            gb(this, 15, 0);
            a = Qa();
            a = eb(a).Za;
            var b = a.google_global_correlator;
            b || (a.google_global_correlator = b = 1 + Math.floor(Math.random() * Math.pow(2, 43)));
            gb(this, 7, b);
            gb(this, 8, {});
            gb(this, 9, {});
            gb(this, 10, {});
            gb(this, 11, []);
            gb(this, 12, 0);
            gb(this, 16, null);
            gb(this, 14, {});
            gb(this, 17, !1)
        },
        ib = {},
        Ta = function() {
            var a = Qa(),
                b = Oa ? "google_persistent_state_async" : "google_persistent_state";
            if (ib[b]) return ib[b];
            var c = "google_persistent_state_async" ==
                b ? {} : a,
                d = a[b];
            return null != d && "object" == typeof d && null != d.S && "object" == typeof d.S ? ib[b] = d : a[b] = ib[b] = new hb(c)
        },
        Ua = function(a) {
            switch (a) {
                case 3:
                    return "google_exp_persistent";
                case 4:
                    return "google_num_sdo_slots";
                case 5:
                    return "google_num_0ad_slots";
                case 6:
                    return "google_num_ad_slots";
                case 7:
                    return "google_correlator";
                case 8:
                    return "google_prev_ad_formats_by_region";
                case 9:
                    return "google_prev_ad_slotnames_by_region";
                case 10:
                    return "google_num_slots_by_channel";
                case 11:
                    return "google_viewed_host_channels";
                case 12:
                    return "google_num_slot_to_show";
                case 14:
                    return "gaGlobal";
                case 15:
                    return "google_num_reactive_ad_slots";
                case 16:
                    return "google_persistent_language";
                case 17:
                    return "google_ose_setup_performed"
            }
            throw Error("unexpected state");
        },
        gb = function(a, b, c) {
            a = a.S;
            b = Ua(b);
            void 0 === a[b] && (a[b] = c)
        };
    var Sa, Ra = function() {
            if (Sa) return !0;
            var a;
            a = Ta();
            var b = Ua(3);
            (a = a.S[b]) && Ma(a) && (b = null, a && a.b && a.b == a.layers && a.g && a.g == a.defaultBucket && (b = new Ka, b.b = a.b, b.g = a.g), a = b, a || (a = new Ka, b = {
                context: "ps::gpes::cf",
                url: Qa().location.href
            }, Za(b)));
            return Ma(a) ? !1 : (Sa = a, !0)
        },
        jb = {
            Ne: {
                W: "17415661",
                R: "17415662"
            },
            Of: {
                W: "453848100",
                R: "453848101"
            },
            nf: {
                W: "828064124",
                R: "828064125"
            },
            mf: {
                W: "828064127",
                R: "828064128"
            },
            of: {
                W: "828064170",
                R: "828064171"
            },
            Re: {
                W: "453848130",
                R: "453848131",
                Wc: "453848132",
                Xc: "453848133"
            },
            Se: {
                W: "453848120",
                R: "453848121",
                Wc: "453848122",
                Xc: "453848123"
            },
            Pf: {
                W: "20040030",
                R: "20040031"
            },
            Rc: {
                W: "24819312",
                R: "24819313"
            },
            Tc: {
                W: "24819310",
                R: "24819311"
            },
            sf: {
                W: "24819308",
                R: "24819309"
            },
            Te: {
                ef: "828064119"
            },
            uf: {
                W: "10573501",
                R: "10573502"
            },
            vf: {
                W: "10573591",
                R: "10573592"
            },
            zf: {
                W: "10573511",
                R: "10573512"
            },
            Af: {
                W: "10573581",
                R: "10573582"
            },
            $e: {
                W: "10573521",
                R: "10573522"
            },
            af: {
                W: "10573571",
                R: "10573572"
            },
            Sc: {
                W: 24819400,
                R: 24819401
            }
        };
    var kb = Array.prototype,
        lb = function(a, b) {
            if (w(a)) return w(b) && 1 == b.length ? a.indexOf(b, 0) : -1;
            for (var c = 0; c < a.length; c++)
                if (c in a && a[c] === b) return c;
            return -1
        },
        E = function(a, b, c) {
            for (var d = a.length, e = w(a) ? a.split("") : a, f = 0; f < d; f++) f in e && b.call(c, e[f], f, a)
        },
        mb = function(a, b, c) {
            for (var d = a.length, e = [], f = 0, g = w(a) ? a.split("") : a, k = 0; k < d; k++)
                if (k in g) {
                    var m = g[k];
                    b.call(c, m, k, a) && (e[f++] = m)
                }
            return e
        },
        nb = function(a, b, c) {
            for (var d = a.length, e = Array(d), f = w(a) ? a.split("") : a, g = 0; g < d; g++) g in f && (e[g] = b.call(c, f[g],
                g, a));
            return e
        },
        ob = function(a, b, c) {
            for (var d = a.length, e = w(a) ? a.split("") : a, f = 0; f < d; f++)
                if (f in e && b.call(c, e[f], f, a)) return !0;
            return !1
        },
        qb = function(a, b, c) {
            b = pb(a, b, c);
            return 0 > b ? null : w(a) ? a.charAt(b) : a[b]
        },
        pb = function(a, b, c) {
            for (var d = a.length, e = w(a) ? a.split("") : a, f = 0; f < d; f++)
                if (f in e && b.call(c, e[f], f, a)) return f;
            return -1
        },
        rb = function(a, b) {
            return 0 <= lb(a, b)
        },
        tb = function() {
            var a = sb;
            if (!v(a))
                for (var b = a.length - 1; 0 <= b; b--) delete a[b];
            a.length = 0
        },
        ub = function(a) {
            return kb.concat.apply(kb, arguments)
        },
        vb = function(a) {
            var b = a.length;
            if (0 < b) {
                for (var c = Array(b), d = 0; d < b; d++) c[d] = a[d];
                return c
            }
            return []
        },
        wb = function(a, b) {
            for (var c = 1; c < arguments.length; c++) {
                var d = arguments[c];
                if (da(d)) {
                    var e = a.length || 0,
                        f = d.length || 0;
                    a.length = e + f;
                    for (var g = 0; g < f; g++) a[e + g] = d[g]
                } else a.push(d)
            }
        },
        xb = function(a, b, c) {
            return 2 >= arguments.length ? kb.slice.call(a, b) : kb.slice.call(a, b, c)
        },
        yb = function(a) {
            for (var b = [], c = 0; c < a; c++) b[c] = 0;
            return b
        },
        zb = function(a) {
            for (var b = [], c = 0; c < arguments.length; c++) {
                var d = arguments[c];
                if (v(d))
                    for (var e =
                        0; e < d.length; e += 8192)
                        for (var f = zb.apply(null, xb(d, e, e + 8192)), g = 0; g < f.length; g++) b.push(f[g]);
                else b.push(d)
            }
            return b
        };
    var Ab = "StopIteration" in l ? l.StopIteration : {
            message: "StopIteration",
            stack: ""
        },
        Bb = function() {};
    Bb.prototype.next = function() {
        throw Ab;
    };
    Bb.prototype.sa = function() {
        return this
    };
    var Cb = function(a) {
            if (a instanceof Bb) return a;
            if ("function" == typeof a.sa) return a.sa(!1);
            if (da(a)) {
                var b = 0,
                    c = new Bb;
                c.next = function() {
                    for (;;) {
                        if (b >= a.length) throw Ab;
                        if (b in a) return a[b++];
                        b++
                    }
                };
                return c
            }
            throw Error("Not implemented");
        },
        Db = function(a, b, c) {
            if (da(a)) try {
                E(a, b, c)
            } catch (d) {
                if (d !== Ab) throw d;
            } else {
                a = Cb(a);
                try {
                    for (;;) b.call(c, a.next(), void 0, a)
                } catch (e) {
                    if (e !== Ab) throw e;
                }
            }
        };
    var Eb = function(a, b, c) {
            for (var d in a) b.call(c, a[d], d, a)
        },
        Gb = function(a) {
            var b = Fb,
                c;
            for (c in b)
                if (a.call(void 0, b[c], c, b)) return !0;
            return !1
        },
        Hb = function(a) {
            var b = 0,
                c;
            for (c in a) b++;
            return b
        },
        Ib = function(a) {
            var b = [],
                c = 0,
                d;
            for (d in a) b[c++] = a[d];
            return b
        },
        Jb = function(a) {
            var b = [],
                c = 0,
                d;
            for (d in a) b[c++] = d;
            return b
        },
        Kb = function(a, b) {
            for (var c = da(b), d = c ? b : arguments, c = c ? 0 : 1; c < d.length && (a = a[d[c]], n(a)); c++);
            return a
        },
        Mb = function(a) {
            var b = Lb,
                c;
            for (c in b)
                if (a.call(void 0, b[c], c, b)) return c
        },
        Nb = function(a,
            b, c) {
            return b in a ? a[b] : c
        },
        Ob = function(a) {
            var b = {},
                c;
            for (c in a) b[c] = a[c];
            return b
        },
        Pb = "constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" "),
        Qb = function(a, b) {
            for (var c, d, e = 1; e < arguments.length; e++) {
                d = arguments[e];
                for (c in d) a[c] = d[c];
                for (var f = 0; f < Pb.length; f++) c = Pb[f], Object.prototype.hasOwnProperty.call(d, c) && (a[c] = d[c])
            }
        },
        Rb = function(a) {
            var b = arguments.length;
            if (1 == b && v(arguments[0])) return Rb.apply(null, arguments[0]);
            if (b % 2) throw Error("Uneven number of arguments");
            for (var c = {}, d = 0; d < b; d += 2) c[arguments[d]] = arguments[d + 1];
            return c
        },
        Sb = function(a) {
            var b = arguments.length;
            if (1 == b && v(arguments[0])) return Sb.apply(null, arguments[0]);
            for (var c = {}, d = 0; d < b; d++) c[arguments[d]] = !0;
            return c
        };
    var F = function(a, b) {
        this.g = {};
        this.b = [];
        this.j = this.h = 0;
        var c = arguments.length;
        if (1 < c) {
            if (c % 2) throw Error("Uneven number of arguments");
            for (var d = 0; d < c; d += 2) Tb(this, arguments[d], arguments[d + 1])
        } else if (a) {
            a instanceof F ? (c = a.la(), d = a.Y()) : (c = Jb(a), d = Ib(a));
            for (var e = 0; e < c.length; e++) Tb(this, c[e], d[e])
        }
    };
    h = F.prototype;
    h.pa = function() {
        return this.h
    };
    h.Y = function() {
        Ub(this);
        for (var a = [], b = 0; b < this.b.length; b++) a.push(this.g[this.b[b]]);
        return a
    };
    h.la = function() {
        Ub(this);
        return this.b.concat()
    };
    h.isEmpty = function() {
        return 0 == this.h
    };
    h.clear = function() {
        this.g = {};
        this.j = this.h = this.b.length = 0
    };
    var Wb = function(a, b) {
            Vb(a.g, b) && (delete a.g[b], a.h--, a.j++, a.b.length > 2 * a.h && Ub(a))
        },
        Ub = function(a) {
            if (a.h != a.b.length) {
                for (var b = 0, c = 0; b < a.b.length;) {
                    var d = a.b[b];
                    Vb(a.g, d) && (a.b[c++] = d);
                    b++
                }
                a.b.length = c
            }
            if (a.h != a.b.length) {
                for (var e = {}, c = b = 0; b < a.b.length;) d = a.b[b], Vb(e, d) || (a.b[c++] = d, e[d] = 1), b++;
                a.b.length = c
            }
        };
    F.prototype.get = function(a, b) {
        return Vb(this.g, a) ? this.g[a] : b
    };
    var Tb = function(a, b, c) {
        Vb(a.g, b) || (a.h++, a.b.push(b), a.j++);
        a.g[b] = c
    };
    F.prototype.forEach = function(a, b) {
        for (var c = this.la(), d = 0; d < c.length; d++) {
            var e = c[d],
                f = this.get(e);
            a.call(b, f, e, this)
        }
    };
    F.prototype.clone = function() {
        return new F(this)
    };
    F.prototype.sa = function(a) {
        Ub(this);
        var b = 0,
            c = this.j,
            d = this,
            e = new Bb;
        e.next = function() {
            if (c != d.j) throw Error("The map has changed since the iterator was created");
            if (b >= d.b.length) throw Ab;
            var e = d.b[b++];
            return a ? e : d.g[e]
        };
        return e
    };
    var Vb = function(a, b) {
        return Object.prototype.hasOwnProperty.call(a, b)
    };
    var Xb = function(a) {
            if ("function" == typeof a.Y) return a.Y();
            if (w(a)) return a.split("");
            if (da(a)) {
                for (var b = [], c = a.length, d = 0; d < c; d++) b.push(a[d]);
                return b
            }
            return Ib(a)
        },
        Yb = function(a, b, c) {
            if ("function" == typeof a.forEach) a.forEach(b, c);
            else if (da(a) || w(a)) E(a, b, c);
            else {
                var d;
                if ("function" == typeof a.la) d = a.la();
                else if ("function" != typeof a.Y)
                    if (da(a) || w(a)) {
                        d = [];
                        for (var e = a.length, f = 0; f < e; f++) d.push(f)
                    } else d = Jb(a);
                else d = void 0;
                for (var e = Xb(a), f = e.length, g = 0; g < f; g++) b.call(c, e[g], d && d[g], a)
            }
        };
    var G;
    a: {
        var Zb = l.navigator;
        if (Zb) {
            var $b = Zb.userAgent;
            if ($b) {
                G = $b;
                break a
            }
        }
        G = ""
    }
    var H = function(a) {
        return -1 != G.indexOf(a)
    };
    var ac = function() {
            return H("Opera") || H("OPR")
        },
        bc = function() {
            return (H("Chrome") || H("CriOS")) && !ac() && !H("Edge")
        };
    var cc = function() {
        return H("iPhone") && !H("iPod") && !H("iPad")
    };
    var dc = ac(),
        I = H("Trident") || H("MSIE"),
        ec = H("Edge"),
        fc = H("Gecko") && !(B(G, "WebKit") && !H("Edge")) && !(H("Trident") || H("MSIE")) && !H("Edge"),
        gc = B(G, "WebKit") && !H("Edge"),
        hc = H("Macintosh"),
        ic = H("Android"),
        jc = cc(),
        kc = H("iPad"),
        lc = function() {
            var a = G;
            if (fc) return /rv\:([^\);]+)(\)|;)/.exec(a);
            if (ec) return /Edge\/([\d\.]+)/.exec(a);
            if (I) return /\b(?:MSIE|rv)[: ]([^\);]+)(\)|;)/.exec(a);
            if (gc) return /WebKit\/(\S+)/.exec(a)
        },
        mc = function() {
            var a = l.document;
            return a ? a.documentMode : void 0
        },
        nc = function() {
            if (dc && l.opera) {
                var a =
                    l.opera.version;
                return y(a) ? a() : a
            }
            var a = "",
                b = lc();
            b && (a = b ? b[1] : "");
            return I && (b = mc(), b > parseFloat(a)) ? String(b) : a
        }(),
        oc = {},
        J = function(a) {
            return oc[a] || (oc[a] = 0 <= xa(nc, a))
        },
        pc = l.document,
        qc = pc && I ? mc() || ("CSS1Compat" == pc.compatMode ? parseInt(nc, 10) : 5) : void 0;
    var rc = /^(?:([^:/?#.]+):)?(?:\/\/(?:([^/?#]*)@)?([^/#?]*?)(?::([0-9]+))?(?=[/#?]|$))?([^?#]+)?(?:\?([^#]*))?(?:#(.*))?$/,
        uc = function(a) {
            if (sc) {
                sc = !1;
                var b = l.location;
                if (b) {
                    var c = b.href;
                    if (c && (c = tc(c)) && c != b.hostname) throw sc = !0, Error();
                }
            }
            return a.match(rc)
        },
        sc = gc,
        tc = function(a) {
            return (a = uc(a)[3] || null) ? decodeURI(a) : a
        },
        vc = function(a, b) {
            if (a)
                for (var c = a.split("&"), d = 0; d < c.length; d++) {
                    var e = c[d].indexOf("="),
                        f = null,
                        g = null;
                    0 <= e ? (f = c[d].substring(0, e), g = c[d].substring(e + 1)) : f = c[d];
                    b(f, g ? decodeURIComponent(g.replace(/\+/g,
                        " ")) : "")
                }
        },
        wc = function(a, b, c) {
            if (v(b))
                for (var d = 0; d < b.length; d++) wc(a, String(b[d]), c);
            else null != b && c.push("&", a, "" === b ? "" : "=", encodeURIComponent(String(b)))
        },
        xc = function(a, b, c) {
            for (c = c || 0; c < b.length; c += 2) wc(b[c], b[c + 1], a);
            return a
        },
        yc = function(a) {
            var b = [],
                c;
            for (c in a) wc(c, a[c], b);
            b[0] = "";
            return b.join("")
        },
        zc = function(a, b) {
            var c = 2 == arguments.length ? xc([a], arguments[1], 0) : xc([a], arguments, 1);
            if (c[1]) {
                var d = c[0],
                    e = d.indexOf("#");
                0 <= e && (c.push(d.substr(e)), c[0] = d = d.substr(0, e));
                e = d.indexOf("?");
                0 >
                    e ? c[1] = "?" : e == d.length - 1 && (c[1] = void 0)
            }
            return c.join("")
        },
        Ac = /#|$/,
        Bc = function(a, b) {
            var c = a.search(Ac),
                d;
            a: {
                d = 0;
                for (var e = b.length; 0 <= (d = a.indexOf(b, d)) && d < c;) {
                    var f = a.charCodeAt(d - 1);
                    if (38 == f || 63 == f)
                        if (f = a.charCodeAt(d + e), !f || 61 == f || 38 == f || 35 == f) break a;
                    d += e + 1
                }
                d = -1
            }
            if (0 > d) return null;
            e = a.indexOf("&", d);
            if (0 > e || e > c) e = c;
            d += b.length + 1;
            return decodeURIComponent(a.substr(d, e - d).replace(/\+/g, " "))
        };
    var Cc = function(a, b) {
        this.b = this.o = this.h = "";
        this.m = null;
        this.l = this.w = "";
        this.j = !1;
        var c;
        a instanceof Cc ? (this.j = n(b) ? b : a.j, Dc(this, a.h), this.o = a.o, this.b = a.b, Ec(this, a.m), this.w = a.w, Fc(this, a.g.clone()), this.l = a.l) : a && (c = uc(String(a))) ? (this.j = !!b, Dc(this, c[1] || "", !0), this.o = Gc(c[2] || ""), this.b = Gc(c[3] || "", !0), Ec(this, c[4]), this.w = Gc(c[5] || "", !0), Fc(this, c[6] || "", !0), this.l = Gc(c[7] || "")) : (this.j = !!b, this.g = new Hc(null, 0, this.j))
    };
    Cc.prototype.toString = function() {
        var a = [],
            b = this.h;
        b && a.push(Ic(b, Jc, !0), ":");
        if (b = this.b) {
            a.push("//");
            var c = this.o;
            c && a.push(Ic(c, Jc, !0), "@");
            a.push(encodeURIComponent(String(b)).replace(/%25([0-9a-fA-F]{2})/g, "%$1"));
            b = this.m;
            null != b && a.push(":", String(b))
        }
        if (b = this.w) this.b && "/" != b.charAt(0) && a.push("/"), a.push(Ic(b, "/" == b.charAt(0) ? Kc : Lc, !0));
        (b = this.g.toString()) && a.push("?", b);
        (b = this.l) && a.push("#", Ic(b, Mc));
        return a.join("")
    };
    Cc.prototype.clone = function() {
        return new Cc(this)
    };
    var Dc = function(a, b, c) {
            a.h = c ? Gc(b, !0) : b;
            a.h && (a.h = a.h.replace(/:$/, ""))
        },
        Nc = function(a) {
            return a.b
        },
        Ec = function(a, b) {
            if (b) {
                b = Number(b);
                if (isNaN(b) || 0 > b) throw Error("Bad port number " + b);
                a.m = b
            } else a.m = null
        },
        Fc = function(a, b, c) {
            b instanceof Hc ? (a.g = b, Oc(a.g, a.j)) : (c || (b = Ic(b, Pc)), a.g = new Hc(b, 0, a.j))
        },
        Qc = function(a) {
            return a.l
        },
        Gc = function(a, b) {
            return a ? b ? decodeURI(a.replace(/%25/g, "%2525")) : decodeURIComponent(a) : ""
        },
        Ic = function(a, b, c) {
            return w(a) ? (a = encodeURI(a).replace(b, Rc), c && (a = a.replace(/%25([0-9a-fA-F]{2})/g,
                "%$1")), a) : null
        },
        Rc = function(a) {
            a = a.charCodeAt(0);
            return "%" + (a >> 4 & 15).toString(16) + (a & 15).toString(16)
        },
        Jc = /[#\/\?@]/g,
        Lc = /[\#\?:]/g,
        Kc = /[\#\?]/g,
        Pc = /[\#\?@]/g,
        Mc = /#/g,
        Hc = function(a, b, c) {
            this.g = this.b = null;
            this.h = a || null;
            this.j = !!c
        },
        Tc = function(a) {
            a.b || (a.b = new F, a.g = 0, a.h && vc(a.h, function(b, c) {
                Sc(a, decodeURIComponent(b.replace(/\+/g, " ")), c)
            }))
        };
    Hc.prototype.pa = function() {
        Tc(this);
        return this.g
    };
    var Sc = function(a, b, c) {
            Tc(a);
            a.h = null;
            b = Uc(a, b);
            var d = a.b.get(b);
            d || Tb(a.b, b, d = []);
            d.push(c);
            a.g++
        },
        Vc = function(a, b) {
            Tc(a);
            b = Uc(a, b);
            Vb(a.b.g, b) && (a.h = null, a.g -= a.b.get(b).length, Wb(a.b, b))
        };
    Hc.prototype.clear = function() {
        this.b = this.h = null;
        this.g = 0
    };
    Hc.prototype.isEmpty = function() {
        Tc(this);
        return 0 == this.g
    };
    var Wc = function(a, b) {
        Tc(a);
        b = Uc(a, b);
        return Vb(a.b.g, b)
    };
    h = Hc.prototype;
    h.la = function() {
        Tc(this);
        for (var a = this.b.Y(), b = this.b.la(), c = [], d = 0; d < b.length; d++)
            for (var e = a[d], f = 0; f < e.length; f++) c.push(b[d]);
        return c
    };
    h.Y = function(a) {
        Tc(this);
        var b = [];
        if (w(a)) Wc(this, a) && (b = ub(b, this.b.get(Uc(this, a))));
        else {
            a = this.b.Y();
            for (var c = 0; c < a.length; c++) b = ub(b, a[c])
        }
        return b
    };
    h.get = function(a, b) {
        var c = a ? this.Y(a) : [];
        return 0 < c.length ? String(c[0]) : b
    };
    h.toString = function() {
        if (this.h) return this.h;
        if (!this.b) return "";
        for (var a = [], b = this.b.la(), c = 0; c < b.length; c++)
            for (var d = b[c], e = encodeURIComponent(String(d)), d = this.Y(d), f = 0; f < d.length; f++) {
                var g = e;
                "" !== d[f] && (g += "=" + encodeURIComponent(String(d[f])));
                a.push(g)
            }
        return this.h = a.join("&")
    };
    h.clone = function() {
        var a = new Hc;
        a.h = this.h;
        this.b && (a.b = this.b.clone(), a.g = this.g);
        return a
    };
    var Uc = function(a, b) {
            var c = String(b);
            a.j && (c = c.toLowerCase());
            return c
        },
        Oc = function(a, b) {
            b && !a.j && (Tc(a), a.h = null, a.b.forEach(function(a, b) {
                var e = b.toLowerCase();
                b != e && (Vc(this, b), Vc(this, e), 0 < a.length && (this.h = null, Tb(this.b, Uc(this, e), vb(a)), this.g += a.length))
            }, a));
            a.j = b
        };
    Hc.prototype.extend = function(a) {
        for (var b = 0; b < arguments.length; b++) Yb(arguments[b], function(a, b) {
            Sc(this, b, a)
        }, this)
    };
    Sb("area base br col command embed hr img input keygen link meta param source track wbr".split(" "));
    var Xc = function() {
            this.g = "";
            this.b = null
        },
        Yc = function(a) {
            var b = new Xc;
            b.g = a;
            b.b = 0
        };
    Yc("<!DOCTYPE html>");
    Yc("");
    var K = function(a, b) {
        this.x = n(a) ? a : 0;
        this.y = n(b) ? b : 0
    };
    K.prototype.clone = function() {
        return new K(this.x, this.y)
    };
    K.prototype.floor = function() {
        this.x = Math.floor(this.x);
        this.y = Math.floor(this.y);
        return this
    };
    K.prototype.round = function() {
        this.x = Math.round(this.x);
        this.y = Math.round(this.y);
        return this
    };
    K.prototype.scale = function(a, b) {
        var c = x(b) ? b : a;
        this.x *= a;
        this.y *= c;
        return this
    };
    var L = function(a, b) {
        this.width = a;
        this.height = b
    };
    h = L.prototype;
    h.clone = function() {
        return new L(this.width, this.height)
    };
    h.isEmpty = function() {
        return !(this.width * this.height)
    };
    h.floor = function() {
        this.width = Math.floor(this.width);
        this.height = Math.floor(this.height);
        return this
    };
    h.round = function() {
        this.width = Math.round(this.width);
        this.height = Math.round(this.height);
        return this
    };
    h.scale = function(a, b) {
        var c = x(b) ? b : a;
        this.width *= a;
        this.height *= c;
        return this
    };
    var Zc = !I || 9 <= qc;
    !fc && !I || I && 9 <= qc || fc && J("1.9.1");
    var $c = I && !J("9");
    var cd = function(a) {
            return a ? new ad(bd(a)) : ja || (ja = new ad)
        },
        dd = function() {
            var a = document;
            return a.querySelectorAll && a.querySelector ? a.querySelectorAll("SCRIPT") : a.getElementsByTagName("SCRIPT")
        },
        fd = function(a, b) {
            Eb(b, function(b, d) {
                "style" == d ? a.style.cssText = b : "class" == d ? a.className = b : "for" == d ? a.htmlFor = b : ed.hasOwnProperty(d) ? a.setAttribute(ed[d], b) : 0 == d.lastIndexOf("aria-", 0) || 0 == d.lastIndexOf("data-", 0) ? a.setAttribute(d, b) : a[d] = b
            })
        },
        ed = {
            cellpadding: "cellPadding",
            cellspacing: "cellSpacing",
            colspan: "colSpan",
            frameborder: "frameBorder",
            height: "height",
            maxlength: "maxLength",
            role: "role",
            rowspan: "rowSpan",
            type: "type",
            usemap: "useMap",
            valign: "vAlign",
            width: "width"
        },
        gd = function(a) {
            a = a.document;
            a = "CSS1Compat" == a.compatMode ? a.documentElement : a.body;
            return new L(a.clientWidth, a.clientHeight)
        },
        hd = function(a) {
            var b = a.b ? a.b : gc || "CSS1Compat" != a.compatMode ? a.body || a.documentElement : a.documentElement;
            a = a.parentWindow || a.defaultView;
            return I && J("10") && a.pageYOffset != b.scrollTop ? new K(b.scrollLeft, b.scrollTop) : new K(a.pageXOffset ||
                b.scrollLeft, a.pageYOffset || b.scrollTop)
        },
        M = function(a) {
            return a ? a.parentWindow || a.defaultView : window
        },
        jd = function(a, b, c) {
            var d = arguments,
                e = document,
                f = d[0],
                g = d[1];
            if (!Zc && g && (g.name || g.type)) {
                f = ["<", f];
                g.name && f.push(' name="', ta(g.name), '"');
                if (g.type) {
                    f.push(' type="', ta(g.type), '"');
                    var k = {};
                    Qb(k, g);
                    delete k.type;
                    g = k
                }
                f.push(">");
                f = f.join("")
            }
            f = e.createElement(f);
            g && (w(g) ? f.className = g : v(g) ? f.className = g.join(" ") : fd(f, g));
            2 < d.length && id(e, f, d);
            return f
        },
        id = function(a, b, c) {
            function d(c) {
                c && b.appendChild(w(c) ?
                    a.createTextNode(c) : c)
            }
            for (var e = 2; e < c.length; e++) {
                var f = c[e];
                !da(f) || ea(f) && 0 < f.nodeType ? d(f) : E(kd(f) ? vb(f) : f, d)
            }
        },
        ld = function(a) {
            a && a.parentNode && a.parentNode.removeChild(a)
        },
        md = function(a, b) {
            if (a.contains && 1 == b.nodeType) return a == b || a.contains(b);
            if ("undefined" != typeof a.compareDocumentPosition) return a == b || Boolean(a.compareDocumentPosition(b) & 16);
            for (; b && a != b;) b = b.parentNode;
            return b == a
        },
        bd = function(a) {
            return 9 == a.nodeType ? a : a.ownerDocument || a.document
        },
        nd = function(a) {
            return a.contentWindow ||
                M(a.contentDocument || a.contentWindow.document)
        },
        od = {
            SCRIPT: 1,
            STYLE: 1,
            HEAD: 1,
            IFRAME: 1,
            OBJECT: 1
        },
        pd = {
            IMG: " ",
            BR: "\n"
        },
        qd = function(a, b, c) {
            if (!(a.nodeName in od))
                if (3 == a.nodeType) c ? b.push(String(a.nodeValue).replace(/(\r\n|\r|\n)/g, "")) : b.push(a.nodeValue);
                else if (a.nodeName in pd) b.push(pd[a.nodeName]);
            else
                for (a = a.firstChild; a;) qd(a, b, c), a = a.nextSibling
        },
        kd = function(a) {
            if (a && "number" == typeof a.length) {
                if (ea(a)) return "function" == typeof a.item || "string" == typeof a.item;
                if (y(a)) return "function" == typeof a.item
            }
            return !1
        },
        ad = function(a) {
            this.b = a || l.document || document
        },
        rd = function(a) {
            return hd(a.b)
        };
    ad.prototype.appendChild = function(a, b) {
        a.appendChild(b)
    };
    ad.prototype.contains = md;
    var sd = function(a) {
        var b = Va(10);
        if ("317150305" == b || "317150306" == b) return null;
        if (b = Qa().g) {
            var c = b[3];
            a && (c = b[4]);
            if (c) return c + ""
        }
        return null
    };

    function td(a, b) {
        var c = sd();
        return c ? c : b ? a.referrer : a.URL
    };
    var ud = "ad_type vpos mridx pos vad_type videoad_start_delay".split(" ");
    var vd = function(a, b, c) {
        this.j = b;
        this.b = c;
        this.h = a
    };
    h = vd.prototype;
    h.kb = function() {
        return this.g
    };
    h.hc = function() {
        return this.j
    };
    h.gc = function() {
        return this.b
    };
    h.hd = function() {
        return 1E3 > this.b ? this.b : 900
    };
    h.rd = function() {
        return this.h
    };
    h.toString = function() {
        return "AdError " + this.gc() + ": " + this.hc() + (null != this.kb() ? " Caused by: " + this.kb() : "")
    };
    var wd = function() {
        this.D = this.D;
        this.w = this.w
    };
    wd.prototype.D = !1;
    wd.prototype.M = function() {
        this.D || (this.D = !0, this.H())
    };
    var xd = function(a, b) {
        a.D ? b.call(void 0) : (a.w || (a.w = []), a.w.push(n(void 0) ? z(b, void 0) : b))
    };
    wd.prototype.H = function() {
        if (this.w)
            for (; this.w.length;) this.w.shift()()
    };
    var yd = function(a) {
        a && "function" == typeof a.M && a.M()
    };
    var N = function(a, b) {
        this.type = a;
        this.b = this.target = b;
        this.Fc = !0
    };
    N.prototype.preventDefault = function() {
        this.Fc = !1
    };
    var zd = function(a, b) {
        N.call(this, "adError");
        this.g = a;
        this.h = b ? b : null
    };
    A(zd, N);
    zd.prototype.j = function() {
        return this.g
    };
    zd.prototype.l = function() {
        return this.h
    };
    var Ad = function(a) {
            this.b = a
        },
        Dd = function() {
            var a = Bd(O);
            return Cd(a, "disableExperiments")
        },
        Cd = function(a, b) {
            if (b in a.b) {
                var c = a.b[b];
                if ("boolean" == typeof c) return c
            }
            return !1
        },
        Ed = function(a) {
            if ("forceExperimentIds" in a.b) {
                a = a.b.forceExperimentIds;
                var b = [],
                    c = 0;
                v(a) && E(a, function(a) {
                    x(a) && (b[c++] = a)
                });
                return b
            }
            return null
        };
    var Fd = function(a) {
            a = String(a);
            if (/^\s*$/.test(a) ? 0 : /^[\],:{}\s\u2028\u2029]*$/.test(a.replace(/\\["\\\/bfnrtu]/g, "@").replace(/"[^"\\\n\r\u2028\u2029\x00-\x08\x0a-\x1f]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:[\s\u2028\u2029]*\[)+/g, ""))) try {
                return eval("(" + a + ")")
            } catch (b) {}
            throw Error("Invalid JSON string: " + a);
        },
        Hd = function(a) {
            return (new Gd(void 0)).A(a)
        },
        Gd = function(a) {
            this.b = a
        };
    Gd.prototype.A = function(a) {
        var b = [];
        Id(this, a, b);
        return b.join("")
    };
    var Id = function(a, b, c) {
            if (null == b) c.push("null");
            else {
                if ("object" == typeof b) {
                    if (v(b)) {
                        var d = b;
                        b = d.length;
                        c.push("[");
                        for (var e = "", f = 0; f < b; f++) c.push(e), e = d[f], Id(a, a.b ? a.b.call(d, String(f), e) : e, c), e = ",";
                        c.push("]");
                        return
                    }
                    if (b instanceof String || b instanceof Number || b instanceof Boolean) b = b.valueOf();
                    else {
                        c.push("{");
                        f = "";
                        for (d in b) Object.prototype.hasOwnProperty.call(b, d) && (e = b[d], "function" != typeof e && (c.push(f), Jd(d, c), c.push(":"), Id(a, a.b ? a.b.call(b, d, e) : e, c), f = ","));
                        c.push("}");
                        return
                    }
                }
                switch (typeof b) {
                    case "string":
                        Jd(b,
                            c);
                        break;
                    case "number":
                        c.push(isFinite(b) && !isNaN(b) ? b : "null");
                        break;
                    case "boolean":
                        c.push(b);
                        break;
                    case "function":
                        break;
                    default:
                        throw Error("Unknown type: " + typeof b);
                }
            }
        },
        Kd = {
            '"': '\\"',
            "\\": "\\\\",
            "/": "\\/",
            "\b": "\\b",
            "\f": "\\f",
            "\n": "\\n",
            "\r": "\\r",
            "\t": "\\t",
            "\x0B": "\\u000b"
        },
        Ld = /\uffff/.test("\uffff") ? /[\\\"\x00-\x1f\x7f-\uffff]/g : /[\\\"\x00-\x1f\x7f-\xff]/g,
        Jd = function(a, b) {
            b.push('"', a.replace(Ld, function(a) {
                    var b = Kd[a];
                    b || (b = "\\u" + (a.charCodeAt(0) | 65536).toString(16).substr(1), Kd[a] = b);
                    return b
                }),
                '"')
        };
    var P = function() {
            this.l = "always";
            this.o = 4;
            this.h = 0;
            this.j = !0;
            this.A = !1;
            this.m = "en";
            this.D = this.w = "";
            this.g = null
        },
        Md = "af am ar bg bn ca cs da de el en en_gb es es_419 et eu fa fi fil fr fr_ca gl gu he hi hr hu id in is it iw ja kn ko lt lv ml mr ms nb nl no pl pt_br pt_pt ro ru sk sl sr sv sw ta te th tr uk ur vi zh_cn zh_hk zh_tw zu".split(" "),
        Nd = function(a) {
            var b = va(a);
            return b = ka(a) ? "" : a.substring(0, 20)
        };
    h = P.prototype;
    h.ee = function(a) {
        this.l = a
    };
    h.lc = function() {
        return this.l
    };
    h.fe = function(a) {
        this.o = a
    };
    h.mc = function() {
        return this.o
    };
    h.ie = function(a) {
        this.B = a
    };
    h.pc = function() {
        return this.B
    };
    h.ke = function(a) {
        "boolean" == typeof a && (this.h = a ? 1 : 0)
    };
    h.ne = function(a) {
        this.h = a
    };
    h.de = function(a) {
        this.j = a
    };
    h.qc = function() {
        return this.j
    };
    h.Me = function() {
        return !1
    };
    h.je = function(a) {
        this.A = a
    };
    h.za = function() {
        return this.A
    };
    h.ma = function() {
        return !1
    };
    h.Qa = function() {
        return !1
    };
    h.ob = function() {
        return !1
    };
    h.Le = function(a) {
        if (null != a) {
            a = a.toLowerCase().replace("-", "_");
            if (!rb(Md, a) && (a = (a = a.match(/^\w{2,3}([-_]|$)/)) ? a[0].replace(/[_-]/g, "") : "", !rb(Md, a))) return;
            this.m = a
        }
    };
    h.hb = function() {
        return this.m
    };
    h.ge = function(a) {
        this.w = Nd(a)
    };
    h.nc = function() {
        return this.w
    };
    h.he = function(a) {
        this.D = Nd(a)
    };
    h.oc = function() {
        return this.D
    };
    var Bd = function(a) {
            if (null == a.g) {
                var b = {},
                    c;
                c = (new Cc(M().location.href)).g;
                if (Wc(c, "tcnfp")) try {
                    b = Fd(c.get("tcnfp"))
                } catch (d) {}
                a.g = new Ad(b)
            }
            return a.g
        },
        O = new P;
    window.console && "function" === typeof window.console.log && z(window.console.log, window.console);
    var Od = function(a) {
            return window.performance && window.performance.timing && window.performance.timing.domLoading && 0 < window.performance.timing[a] ? (a = ia() - window.performance.timing[a], Math.round(a / 1E3)) : null
        },
        Pd = function() {
            this.domLoading = Od("domLoading");
            this.domComplete = Od("domComplete");
            this.unloadEventStart = Od("unloadEventStart")
        };
    Pd.prototype.toString = function() {
        function a(a) {
            a = Nb(c, a);
            null != a ? b.push("" + a) : b.push("u")
        }
        var b = [],
            c = this;
        a("domLoading");
        a("domComplete");
        a("unloadEventStart");
        return b.join(".")
    };
    var Qd = function(a) {
        var b = {},
            c = new Pd,
            d = null;
        null != c.domLoading && (d = c.domLoading);
        null == d && null != a && (d = a);
        b.pt = c;
        b.td = d;
        return b
    };
    var Rd = function(a) {
        for (var b = [], c = a = M(a.ownerDocument); c != a.top; c = c.parent)
            if (c.frameElement) b.push(c.frameElement);
            else break;
        return b
    };
    var Sd = function(a, b, c, d) {
        this.top = a;
        this.right = b;
        this.bottom = c;
        this.left = d
    };
    h = Sd.prototype;
    h.clone = function() {
        return new Sd(this.top, this.right, this.bottom, this.left)
    };
    h.contains = function(a) {
        return this && a ? a instanceof Sd ? a.left >= this.left && a.right <= this.right && a.top >= this.top && a.bottom <= this.bottom : a.x >= this.left && a.x <= this.right && a.y >= this.top && a.y <= this.bottom : !1
    };
    h.floor = function() {
        this.top = Math.floor(this.top);
        this.right = Math.floor(this.right);
        this.bottom = Math.floor(this.bottom);
        this.left = Math.floor(this.left);
        return this
    };
    h.round = function() {
        this.top = Math.round(this.top);
        this.right = Math.round(this.right);
        this.bottom = Math.round(this.bottom);
        this.left = Math.round(this.left);
        return this
    };
    h.scale = function(a, b) {
        var c = x(b) ? b : a;
        this.left *= a;
        this.right *= a;
        this.top *= c;
        this.bottom *= c;
        return this
    };
    var Td = function(a, b, c, d) {
        this.left = a;
        this.top = b;
        this.width = c;
        this.height = d
    };
    Td.prototype.clone = function() {
        return new Td(this.left, this.top, this.width, this.height)
    };
    var Ud = function(a) {
        return new Sd(a.top, a.left + a.width, a.top + a.height, a.left)
    };
    Td.prototype.contains = function(a) {
        return a instanceof Td ? this.left <= a.left && this.left + this.width >= a.left + a.width && this.top <= a.top && this.top + this.height >= a.top + a.height : a.x >= this.left && a.x <= this.left + this.width && a.y >= this.top && a.y <= this.top + this.height
    };
    Td.prototype.floor = function() {
        this.left = Math.floor(this.left);
        this.top = Math.floor(this.top);
        this.width = Math.floor(this.width);
        this.height = Math.floor(this.height);
        return this
    };
    Td.prototype.round = function() {
        this.left = Math.round(this.left);
        this.top = Math.round(this.top);
        this.width = Math.round(this.width);
        this.height = Math.round(this.height);
        return this
    };
    Td.prototype.scale = function(a, b) {
        var c = x(b) ? b : a;
        this.left *= a;
        this.width *= a;
        this.top *= c;
        this.height *= c;
        return this
    };
    var Vd = {},
        Wd = function(a) {
            var b;
            try {
                b = a.getBoundingClientRect()
            } catch (c) {
                return {
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0
                }
            }
            I && a.ownerDocument.body && (a = a.ownerDocument, b.left -= a.documentElement.clientLeft + a.body.clientLeft, b.top -= a.documentElement.clientTop + a.body.clientTop);
            return b
        },
        Xd = function(a) {
            var b = bd(a),
                c = new K(0, 0),
                d;
            d = b ? bd(b) : document;
            var e;
            (e = !I || 9 <= qc) || (e = "CSS1Compat" == cd(d).b.compatMode);
            if (a == (e ? d.documentElement : d.body)) return c;
            a = Wd(a);
            b = rd(cd(b));
            c.x = a.left + b.x;
            c.y = a.top + b.y;
            return c
        },
        Yd = function(a,
            b) {
            var c = new K(0, 0),
                d = M(bd(a)),
                e = a;
            do {
                var f;
                d == b ? f = Xd(e) : (f = Wd(e), f = new K(f.left, f.top));
                c.x += f.x;
                c.y += f.y
            } while (d && d != b && d != d.parent && (e = d.frameElement) && (d = d.parent));
            return c
        },
        Zd = function(a) {
            "number" == typeof a && (a = a + "px");
            return a
        },
        ae = function(a) {
            var b = $d,
                c;
            a: {
                c = bd(a);
                if (c.defaultView && c.defaultView.getComputedStyle && (c = c.defaultView.getComputedStyle(a, null))) {
                    c = c.display || c.getPropertyValue("display") || "";
                    break a
                }
                c = ""
            }
            if ("none" != (c || (a.currentStyle ? a.currentStyle.display : null) || a.style && a.style.display)) return b(a);
            c = a.style;
            var d = c.display,
                e = c.visibility,
                f = c.position;
            c.visibility = "hidden";
            c.position = "absolute";
            c.display = "inline";
            a = b(a);
            c.display = d;
            c.position = f;
            c.visibility = e;
            return a
        },
        $d = function(a) {
            var b = a.offsetWidth,
                c = a.offsetHeight,
                d = gc && !b && !c;
            return n(b) && !d || !a.getBoundingClientRect ? new L(b, c) : (a = Wd(a), new L(a.right - a.left, a.bottom - a.top))
        };
    var be = null,
        ce = function() {
            this.b = {};
            this.g = 0
        },
        de = function(a, b) {
            this.l = a;
            this.h = !0;
            this.b = b
        };
    de.prototype.A = function() {
        return this.h ? this.g() : ""
    };
    de.prototype.g = function() {
        return String(this.b)
    };
    var ee = function(a, b, c) {
        de.call(this, a, c);
        this.j = b;
        this.b = !!c
    };
    A(ee, de);
    ee.prototype.g = function() {
        return this.b ? "1" : "0"
    };
    var fe = function(a) {
        de.call(this, "sv", a);
        this.b = null == a ? "1" : "2"
    };
    A(fe, de);
    fe.prototype.g = function() {
        return String(this.b)
    };
    var ge = function(a, b) {
        de.call(this, a, b)
    };
    A(ge, de);
    ge.prototype.g = function() {
        return this.b ? Math.round(this.b.top) + "." + Math.round(this.b.left) + "." + (Math.round(this.b.top) + Math.round(this.b.height)) + "." + (Math.round(this.b.left) + Math.round(this.b.width)) : ""
    };
    var he = function(a) {
            if (a.match(/^-?[0-9]+\.-?[0-9]+\.-?[0-9]+\.-?[0-9]+$/)) {
                a = a.split(".");
                var b = Number(a[0]),
                    c = Number(a[1]);
                return new ge("", new Td(c, b, Number(a[3]) - c, Number(a[2]) - b))
            }
            return new ge("", new Td(0, 0, 0, 0))
        },
        ie = function() {
            be || (be = new ce);
            return be
        },
        R = function(a, b) {
            a.b[b.l] = b
        };
    ce.prototype.A = function(a) {
        var b = [];
        a || (a = 0);
        for (var c in this.b) {
            var d = this.b[c];
            d instanceof ee && d.b && (a |= d.j);
            (d = this.b[c].A()) && b.push(c + d)
        }
        b.push("eb" + String(a));
        return b.join("_")
    };
    var je = function(a) {
            var b = new Td(-Number.MAX_VALUE / 2, -Number.MAX_VALUE / 2, Number.MAX_VALUE, Number.MAX_VALUE),
                c = new Td(0, 0, 0, 0);
            if (!a || 0 == a.length) return c;
            for (var d = 0; d < a.length; d++) {
                var e;
                a: {
                    e = b;
                    var f = a[d],
                        g = Math.max(e.left, f.left),
                        k = Math.min(e.left + e.width, f.left + f.width);
                    if (g <= k) {
                        var m = Math.max(e.top, f.top),
                            f = Math.min(e.top + e.height, f.top + f.height);
                        if (m <= f) {
                            e.left = g;
                            e.top = m;
                            e.width = k - g;
                            e.height = f - m;
                            e = !0;
                            break a
                        }
                    }
                    e = !1
                }
                if (!e) return c
            }
            return b
        },
        ke = function(a, b) {
            var c = a.getBoundingClientRect(),
                d = Yd(a,
                    b);
            return new Td(Math.round(d.x), Math.round(d.y), Math.round(c.right - c.left), Math.round(c.bottom - c.top))
        },
        le = function(a, b, c) {
            if (b && c) {
                var d;
                a: {
                    d = Math.max(b.left, c.left);
                    var e = Math.min(b.left + b.width, c.left + c.width);
                    if (d <= e) {
                        var f = Math.max(b.top, c.top),
                            g = Math.min(b.top + b.height, c.top + c.height);
                        if (f <= g) {
                            d = new Td(d, f, e - d, g - f);
                            break a
                        }
                    }
                    d = null
                }
                e = d ? d.height * d.width : 0;
                f = d ? b.height * b.width : 0;
                d = d && f ? Math.round(e / f * 100) : 0;
                R(a, new de("vp", d));
                d && 0 < d ? (e = Ud(b), f = Ud(c), e = e.top >= f.top && e.top < f.bottom) : e = !1;
                R(a, new ee("ct",
                    512, e));
                d && 0 < d ? (e = Ud(b), f = Ud(c), e = e.bottom <= f.bottom && e.bottom > f.top) : e = !1;
                R(a, new ee("vb", 1024, e));
                d && 0 < d ? (e = Ud(b), f = Ud(c), e = e.left >= f.left && e.left < f.right) : e = !1;
                R(a, new ee("vl", 2048, e));
                d && 0 < d ? (b = Ud(b), c = Ud(c), c = b.right <= c.right && b.right > c.left) : c = !1;
                R(a, new ee("vr", 4096, c))
            }
        };
    var me = !I || 9 <= qc,
        ne = I && !J("9");
    !gc || J("528");
    fc && J("1.9b") || I && J("8") || dc && J("9.5") || gc && J("528");
    fc && !J("8") || I && J("9");
    var oe = function(a, b) {
        N.call(this, a ? a.type : "");
        this.b = this.target = null;
        this.button = this.screenY = this.screenX = this.clientY = this.clientX = 0;
        this.metaKey = this.shiftKey = this.altKey = this.ctrlKey = !1;
        this.g = this.state = null;
        if (a) {
            this.type = a.type;
            this.target = a.target || a.srcElement;
            this.b = b;
            var c = a.relatedTarget;
            c && fc && Ca(c, "nodeName");
            this.clientX = void 0 !== a.clientX ? a.clientX : a.pageX;
            this.clientY = void 0 !== a.clientY ? a.clientY : a.pageY;
            this.screenX = a.screenX || 0;
            this.screenY = a.screenY || 0;
            this.button = a.button;
            this.ctrlKey =
                a.ctrlKey;
            this.altKey = a.altKey;
            this.shiftKey = a.shiftKey;
            this.metaKey = a.metaKey;
            this.state = a.state;
            this.g = a;
            a.defaultPrevented && this.preventDefault()
        }
    };
    A(oe, N);
    oe.prototype.preventDefault = function() {
        oe.X.preventDefault.call(this);
        var a = this.g;
        if (a.preventDefault) a.preventDefault();
        else if (a.returnValue = !1, ne) try {
            if (a.ctrlKey || 112 <= a.keyCode && 123 >= a.keyCode) a.keyCode = -1
        } catch (b) {}
    };
    var pe = "closure_listenable_" + (1E6 * Math.random() | 0),
        qe = function(a) {
            return !(!a || !a[pe])
        },
        re = 0;
    var se = function(a, b, c, d, e) {
            this.listener = a;
            this.b = null;
            this.src = b;
            this.type = c;
            this.Ea = !!d;
            this.Ka = e;
            this.ib = ++re;
            this.ra = this.Da = !1
        },
        te = function(a) {
            a.ra = !0;
            a.listener = null;
            a.b = null;
            a.src = null;
            a.Ka = null
        };
    var ue = function(a) {
            this.src = a;
            this.b = {};
            this.g = 0
        },
        we = function(a, b, c, d, e, f) {
            var g = b.toString();
            b = a.b[g];
            b || (b = a.b[g] = [], a.g++);
            var k = ve(b, c, e, f); - 1 < k ? (a = b[k], d || (a.Da = !1)) : (a = new se(c, a.src, g, !!e, f), a.Da = d, b.push(a));
            return a
        },
        xe = function(a, b) {
            var c = b.type;
            if (c in a.b) {
                var d = a.b[c],
                    e = lb(d, b),
                    f;
                (f = 0 <= e) && kb.splice.call(d, e, 1);
                f && (te(b), 0 == a.b[c].length && (delete a.b[c], a.g--))
            }
        },
        ye = function(a, b, c, d, e) {
            a = a.b[b.toString()];
            b = -1;
            a && (b = ve(a, c, d, e));
            return -1 < b ? a[b] : null
        },
        ve = function(a, b, c, d) {
            for (var e = 0; e <
                a.length; ++e) {
                var f = a[e];
                if (!f.ra && f.listener == b && f.Ea == !!c && f.Ka == d) return e
            }
            return -1
        };
    var ze = "closure_lm_" + (1E6 * Math.random() | 0),
        Ae = {},
        Be = 0,
        Ce = function(a, b, c, d, e) {
            if (v(b)) {
                for (var f = 0; f < b.length; f++) Ce(a, b[f], c, d, e);
                return null
            }
            c = De(c);
            return qe(a) ? a.C(b, c, d, e) : Ee(a, b, c, !1, d, e)
        },
        Ee = function(a, b, c, d, e, f) {
            if (!b) throw Error("Invalid event type");
            var g = !!e,
                k = Fe(a);
            k || (a[ze] = k = new ue(a));
            c = we(k, b, c, d, e, f);
            if (c.b) return c;
            d = Ge();
            c.b = d;
            d.src = a;
            d.listener = c;
            if (a.addEventListener) a.addEventListener(b.toString(), d, g);
            else if (a.attachEvent) a.attachEvent(He(b.toString()), d);
            else throw Error("addEventListener and attachEvent are unavailable.");
            Be++;
            return c
        },
        Ge = function() {
            var a = Ie,
                b = me ? function(c) {
                    return a.call(b.src, b.listener, c)
                } : function(c) {
                    c = a.call(b.src, b.listener, c);
                    if (!c) return c
                };
            return b
        },
        Je = function(a, b, c, d, e) {
            if (v(b)) {
                for (var f = 0; f < b.length; f++) Je(a, b[f], c, d, e);
                return null
            }
            c = De(c);
            return qe(a) ? we(a.ha, String(b), c, !0, d, e) : Ee(a, b, c, !0, d, e)
        },
        Ke = function(a, b, c, d, e) {
            if (v(b))
                for (var f = 0; f < b.length; f++) Ke(a, b[f], c, d, e);
            else c = De(c), qe(a) ? a.Ba(b, c, d, e) : a && (a = Fe(a)) && (b = ye(a, b, c, !!d, e)) && Le(b)
        },
        Le = function(a) {
            if (!x(a) && a && !a.ra) {
                var b =
                    a.src;
                if (qe(b)) xe(b.ha, a);
                else {
                    var c = a.type,
                        d = a.b;
                    b.removeEventListener ? b.removeEventListener(c, d, a.Ea) : b.detachEvent && b.detachEvent(He(c), d);
                    Be--;
                    (c = Fe(b)) ? (xe(c, a), 0 == c.g && (c.src = null, b[ze] = null)) : te(a)
                }
            }
        },
        He = function(a) {
            return a in Ae ? Ae[a] : Ae[a] = "on" + a
        },
        Ne = function(a, b, c, d) {
            var e = !0;
            if (a = Fe(a))
                if (b = a.b[b.toString()])
                    for (b = b.concat(), a = 0; a < b.length; a++) {
                        var f = b[a];
                        f && f.Ea == c && !f.ra && (f = Me(f, d), e = e && !1 !== f)
                    }
                return e
        },
        Me = function(a, b) {
            var c = a.listener,
                d = a.Ka || a.src;
            a.Da && Le(a);
            return c.call(d, b)
        },
        Ie = function(a, b) {
            if (a.ra) return !0;
            if (!me) {
                var c = b || aa("window.event"),
                    d = new oe(c, this),
                    e = !0;
                if (!(0 > c.keyCode || void 0 != c.returnValue)) {
                    a: {
                        var f = !1;
                        if (0 == c.keyCode) try {
                            c.keyCode = -1;
                            break a
                        } catch (g) {
                            f = !0
                        }
                        if (f || void 0 == c.returnValue) c.returnValue = !0
                    }
                    c = [];
                    for (f = d.b; f; f = f.parentNode) c.push(f);
                    for (var f = a.type, k = c.length - 1; 0 <= k; k--) {
                        d.b = c[k];
                        var m = Ne(c[k], f, !0, d),
                            e = e && m
                    }
                    for (k = 0; k < c.length; k++) d.b = c[k], m = Ne(c[k], f, !1, d), e = e && m
                }
                return e
            }
            return Me(a, new oe(b, this))
        },
        Fe = function(a) {
            a = a[ze];
            return a instanceof
            ue ? a : null
        },
        Oe = "__closure_events_fn_" + (1E9 * Math.random() >>> 0),
        De = function(a) {
            if (y(a)) return a;
            a[Oe] || (a[Oe] = function(b) {
                return a.handleEvent(b)
            });
            return a[Oe]
        };
    var S = function() {
        wd.call(this);
        this.ha = new ue(this);
        this.oa = this;
        this.ga = null
    };
    A(S, wd);
    S.prototype[pe] = !0;
    h = S.prototype;
    h.addEventListener = function(a, b, c, d) {
        Ce(this, a, b, c, d)
    };
    h.removeEventListener = function(a, b, c, d) {
        Ke(this, a, b, c, d)
    };
    h.dispatchEvent = function(a) {
        var b, c = this.ga;
        if (c)
            for (b = []; c; c = c.ga) b.push(c);
        var c = this.oa,
            d = a.type || a;
        if (w(a)) a = new N(a, c);
        else if (a instanceof N) a.target = a.target || c;
        else {
            var e = a;
            a = new N(d, c);
            Qb(a, e)
        }
        var e = !0,
            f;
        if (b)
            for (var g = b.length - 1; 0 <= g; g--) f = a.b = b[g], e = Pe(f, d, !0, a) && e;
        f = a.b = c;
        e = Pe(f, d, !0, a) && e;
        e = Pe(f, d, !1, a) && e;
        if (b)
            for (g = 0; g < b.length; g++) f = a.b = b[g], e = Pe(f, d, !1, a) && e;
        return e
    };
    h.H = function() {
        S.X.H.call(this);
        if (this.ha) {
            var a = this.ha,
                b = 0,
                c;
            for (c in a.b) {
                for (var d = a.b[c], e = 0; e < d.length; e++)++b, te(d[e]);
                delete a.b[c];
                a.g--
            }
        }
        this.ga = null
    };
    h.C = function(a, b, c, d) {
        return we(this.ha, String(a), b, !1, c, d)
    };
    h.Ba = function(a, b, c, d) {
        var e;
        e = this.ha;
        a = String(a).toString();
        if (a in e.b) {
            var f = e.b[a];
            b = ve(f, b, c, d); - 1 < b ? (te(f[b]), kb.splice.call(f, b, 1), 0 == f.length && (delete e.b[a], e.g--), e = !0) : e = !1
        } else e = !1;
        return e
    };
    var Pe = function(a, b, c, d) {
        b = a.ha.b[String(b)];
        if (!b) return !0;
        b = b.concat();
        for (var e = !0, f = 0; f < b.length; ++f) {
            var g = b[f];
            if (g && !g.ra && g.Ea == c) {
                var k = g.listener,
                    m = g.Ka || g.src;
                g.Da && xe(a.ha, g);
                e = !1 !== k.call(m, d) && e
            }
        }
        return e && 0 != d.Fc
    };
    var Qe = function(a, b) {
        S.call(this);
        this.h = a || 1;
        this.g = b || l;
        this.l = z(this.o, this);
        this.m = ia()
    };
    A(Qe, S);
    Qe.prototype.j = !1;
    Qe.prototype.b = null;
    Qe.prototype.o = function() {
        if (this.j) {
            var a = ia() - this.m;
            0 < a && a < .8 * this.h ? this.b = this.g.setTimeout(this.l, this.h - a) : (this.b && (this.g.clearTimeout(this.b), this.b = null), this.dispatchEvent("tick"), this.j && (this.b = this.g.setTimeout(this.l, this.h), this.m = ia()))
        }
    };
    Qe.prototype.start = function() {
        this.j = !0;
        this.b || (this.b = this.g.setTimeout(this.l, this.h), this.m = ia())
    };
    var Re = function(a) {
        a.j = !1;
        a.b && (a.g.clearTimeout(a.b), a.b = null)
    };
    Qe.prototype.H = function() {
        Qe.X.H.call(this);
        Re(this);
        delete this.g
    };
    var Se = function(a, b, c) {
        if (y(a)) c && (a = z(a, c));
        else if (a && "function" == typeof a.handleEvent) a = z(a.handleEvent, a);
        else throw Error("Invalid listener argument");
        return 2147483647 < b ? -1 : l.setTimeout(a, b || 0)
    };
    var Te = function(a) {
            this.b = Rb.apply(null, arguments);
            return this
        },
        Ue = function(a, b) {
            var c = Nb(a.b, "eb", 0);
            a.b.eb = c | b
        };
    Te.prototype.get = function(a) {
        return Nb(this.b, a, null)
    };
    Te.prototype.extend = function(a) {
        Qb(this.b, a)
    };
    Te.prototype.A = function() {
        var a = [],
            b;
        for (b in this.b) a.push(b + this.b[b]);
        return a.join("_")
    };
    var Ve = function(a, b) {
        var c = 0;
        Kb(M(), "ima", "video", "client", "tagged") && (c = 1);
        var d;
        d = null;
        a && (d = a());
        if (d) {
            var e = d;
            d = ie();
            d.b = {};
            var f = new ee("ef", 32, !0);
            f.h = !1;
            R(d, f);
            f = M().document;
            f = f.webkitVisibilityState || f.mozVisibilityState || f.visibilityState || f.msVisibilityState || "";
            R(d, new ee("tv", 64, "hidden" != f.toLowerCase().substring(f.length - 6) ? !0 : !1));
            var g;
            try {
                var k;
                var m = M().top;
                try {
                    k = !!m.location.href || "" === m.location.href
                } catch (p) {
                    k = !1
                }
                if (k) {
                    var t = Rd(e);
                    g = t && 0 != t.length ? "1" : "0"
                } else g = "2"
            } catch (D) {
                g =
                    "2"
            }
            R(d, new de("is", g));
            t = k = M().top;
            "2" == g && (t = M());
            m = ke(e, t);
            R(d, new ge("er", m));
            var q;
            try {
                q = t.document && !t.document.body ? null : gd(t || window)
            } catch (fb) {
                q = null
            }
            R(d, new fe(q));
            q ? (t = rd(cd(t.document)), R(d, new ee("sp", 16384, !!t)), q = t ? new Td(t.x, t.y, q.width, q.height) : null) : q = null;
            R(d, new ge("vi", q));
            if (q && "1" == g) {
                g = Rd(e);
                e = [];
                for (t = 0; t < g.length; t++)(f = ke(g[t], k)) && e.push(f);
                e.push(q);
                q = je(e)
            }
            le(d, m, q);
            d.g && (g = Math.round(ia() / 1E3) - d.g, R(d, new de("ts", g)));
            d.g = Math.round(ia() / 1E3)
        } else d = ie(), d.b = {}, d.g =
            Math.round(ia() / 1E3), R(d, new ee("ef", 32, !1));
        this.h = d;
        this.b = new Te("ta", c, "ve", 3);
        c && Ue(this.b, 1);
        Kb(M(), "ima", "video", "client", "crossdomainTag") && Ue(this.b, 4);
        Kb(M(), "ima", "video", "client", "sdkTag") && Ue(this.b, 8);
        Kb(M(), "ima", "video", "client", "jsTag") && Ue(this.b, 2);
        b && Nb(b, "fullscreen", !1) && Ue(this.b, 16);
        this.g = d = null;
        if (c && (c = Kb(M(), "ima", "video", "client"), c.getEData)) {
            this.g = c.getEData();
            if (c = Kb(M(), "ima", "video", "client", "getLastSnapshotFromTop"))
                if (g = c()) this.g.extendWithDataFromTopIframe(g.buckets,
                    g.tt, g.pd), c = this.h, d = g.er, g = g.vi, d && g && (d = he(d).b, g = he(g).b, e = null, Nb(c.b, "er", null) && (e = Nb(c.b, "er", null).b, e.top += d.top, e.left += d.left, R(c, new ge("er", e))), Nb(c.b, "vi", null) && (q = Nb(c.b, "vi", null).b, q.top += d.top, q.left += d.left, k = [], k.push(q), k.push(d), k.push(g), d = je(k), le(c, e, d), R(c, new ge("vi", g))));
            d = this.g.getTimeSinceTagLoadSeconds()
        }
        this.b.extend(Qd(d))
    };
    Ve.prototype.A = function() {
        var a = [],
            b = Number(this.b.get("eb")),
            c = this.b.b;
        "eb" in c && delete c.eb;
        (c = this.b.A()) && a.push(c);
        this.g && (c = this.g.serialize()) && a.push(c);
        (c = this.h.A(b)) && a.push(c);
        this.b.b.eb = b;
        return a.join("_")
    };
    var We = function(a, b) {
        try {
            return (new Ve(a, b)).A()
        } catch (c) {
            return "tle;" + ua(c.name, 12) + ";" + ua(c.message, 40)
        }
    };
    var Lb = {
            Sb: "start",
            FIRST_QUARTILE: "firstquartile",
            MIDPOINT: "midpoint",
            THIRD_QUARTILE: "thirdquartile",
            COMPLETE: "complete",
            Pc: "metric",
            Ob: "pause",
            Uc: "resume",
            SKIPPED: "skip",
            $c: "viewable_impression",
            Qc: "mute",
            Yc: "unmute",
            FULLSCREEN: "fullscreen",
            Lc: "exitfullscreen",
            Kc: "custom_viewable_impression"
        },
        Xe = ["start", "firstquartile", "midpoint", "thirdquartile", "resume"],
        Ye = {
            Nf: -1,
            Sb: 0,
            FIRST_QUARTILE: 1,
            MIDPOINT: 2,
            THIRD_QUARTILE: 3,
            COMPLETE: 4,
            Pc: 5,
            Ob: 6,
            Uc: 7,
            SKIPPED: 8,
            $c: 9,
            Qc: 10,
            Yc: 11,
            FULLSCREEN: 12,
            Lc: 13,
            Kc: 14
        };
    var Ze = {
            Zc: "ud=1",
            Vc: "ts=0",
            wf: "sc=1",
            Ze: "gz=1",
            Oc: "lp=1"
        },
        $e = {
            Nc: "la="
        };
    var af = !1,
        bf = "",
        cf = function(a) {
            a = a.match(/[\d]+/g);
            if (!a) return "";
            a.length = 3;
            return a.join(".")
        };
    if (navigator.plugins && navigator.plugins.length) {
        var df = navigator.plugins["Shockwave Flash"];
        df && (af = !0, df.description && (bf = cf(df.description)));
        navigator.plugins["Shockwave Flash 2.0"] && (af = !0, bf = "2.0.0.11")
    } else if (navigator.mimeTypes && navigator.mimeTypes.length) {
        var ef = navigator.mimeTypes["application/x-shockwave-flash"];
        (af = ef && ef.enabledPlugin) && (bf = cf(ef.enabledPlugin.description))
    } else try {
        var ff = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7"),
            af = !0,
            bf = cf(ff.GetVariable("$version"))
    } catch (gf) {
        try {
            ff =
                new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6"), af = !0, bf = "6.0.21"
        } catch (hf) {
            try {
                ff = new ActiveXObject("ShockwaveFlash.ShockwaveFlash"), af = !0, bf = cf(ff.GetVariable("$version"))
            } catch (jf) {}
        }
    }
    var kf = af,
        lf = bf;
    var mf = H("Firefox"),
        nf = cc() || H("iPod"),
        of = H("iPad"),
        pf = H("Android") && !(bc() || H("Firefox") || ac() || H("Silk")),
        qf = bc(),
        rf = H("Safari") && !(bc() || H("Coast") || ac() || H("Edge") || H("Silk") || H("Android")) && !(cc() || H("iPad") || H("iPod"));
    var sf = function(a) {
            return (a = a.exec(G)) ? a[1] : ""
        },
        tf = function() {
            if (mf) return sf(/Firefox\/([0-9.]+)/);
            if (I || dc) return nc;
            if (qf) return sf(/Chrome\/([0-9.]+)/);
            if (rf && !(cc() || H("iPad") || H("iPod"))) return sf(/Version\/([0-9.]+)/);
            if (nf || of) {
                var a;
                if (a = /Version\/(\S+).*Mobile\/(\S+)/.exec(G)) return a[1] + "." + a[2]
            } else if (pf) return (a = sf(/Android\s+([0-9.]+)/)) ? a : sf(/Version\/([0-9.]+)/);
            return ""
        }();
    if (Ga && Ga.URL) var uf = Ga.URL,
        Wa = !(uf && (0 < uf.indexOf("?google_debug") || 0 < uf.indexOf("&google_debug") || 0 < uf.indexOf("#google_debug")));
    var vf = function(a, b, c, d) {
        c = cb(d || "osd_or_lidar::" + b, c, void 0, void 0, void 0);
        a.addEventListener ? a.addEventListener(b, c, !1) : a.attachEvent && a.attachEvent("on" + b, c);
        return c
    };
    var wf = {},
        xf = null;
    wf.le = 0;
    wf.nt = 2;
    wf.Fr = 3;
    var yf = function(a, b) {
            var c = a || C;
            c.top != c && (c = c.top);
            try {
                return c.document && !c.document.body ? new L(-1, -1) : b ? (new L(c.innerWidth, c.innerHeight)).round() : gd(c || window).round()
            } catch (d) {
                return new L(-12245933, -12245933)
            }
        },
        zf = 0,
        Gf = function() {
            var a = Af().g,
                b = 0 <= Bf ? Cf() - Bf : -1,
                c = Df ? Cf() - Ef : -1,
                d = 0 <= Ff ? Cf() - Ff : -1,
                e;
            if (79463068 == a) return 500;
            if (947190538 == a) a = [4E3], e = [250, 1E3];
            else if (947190541 == a) a = [4E3], e = [100, 1E3];
            else {
                if (947190542 == a) return 100;
                if (79463069 == a) return 200;
                a = [2E3, 4E3];
                e = [250, 500, 1E3]
            }
            var f =
                b; - 1 != c && c < b && (f = c);
            for (var g, b = 0; b < a.length; ++b)
                if (f < a[b]) {
                    g = e[b];
                    break
                }
            void 0 === g && (g = e[a.length]);
            return -1 != d && 1500 < d && 4E3 > d ? 500 : g
        },
        Hf = (new Date).getTime(),
        Bf = -1,
        Df = !1,
        Ef = -1,
        Ff = -1,
        Cf = function() {
            return (new Date).getTime() - Hf
        },
        If = function(a) {
            var b = [];
            Eb(a, function(a, d) {
                d in Object.prototype || "undefined" == typeof a || (v(a) && (a = a.join(",")), b.push([d, "=", a].join("")))
            });
            return b.join("&")
        },
        Jf = function() {
            var a = jd("div");
            a.style.cssText = "position:relative;left:0px;top:0px;width:0;height:0;";
            return a
        },
        Kf = function(a) {
            for (var b; a && a != a.parentElement;) {
                if (b = a.style) {
                    var c = a;
                    b = c.style[za()];
                    if ("undefined" === typeof b) {
                        b = c.style;
                        var d = Vd.display;
                        if (!d) {
                            var e = za(),
                                d = e;
                            void 0 === c.style[e] && (e = (gc ? "Webkit" : fc ? "Moz" : I ? "ms" : dc ? "O" : null) + Aa(e), void 0 !== c.style[e] && (d = e));
                            Vd.display = d
                        }
                        b = b[d] || ""
                    }
                    b = "none" == b
                }
                if (b) return !0;
                b = a;
                a = a.parentElement
            }
            if (b && (a = bd(b))) {
                var f, g;
                try {
                    if (f = M(a)) g = f.frameElement
                } catch (k) {
                    return !1
                }
                if (f && g && f != f.parent) return Kf(g)
            }
            return !1
        };
    wf.Po = 5;
    wf.me = 1;
    wf.om = 4;
    var Lf = function(a) {
        wf.e = -1;
        wf.i = 6;
        wf.n = 7;
        wf.t = 8;
        if (!xf) {
            var b = [];
            E(Jb(wf), function(a) {
                b[wf[a] + 1] = a
            });
            var c = b.join("");
            xf = (c = a && a[c]) && z(c, a)
        }
        return xf
    };
    var Mf = function(a, b) {
            this.l = null;
            this.w = a;
            this.D = b || 1
        },
        Nf = function(a, b) {
            var c = b.right - b.left,
                d = b.bottom - b.top,
                e = Math.floor(c / 2),
                f = Math.floor(d / 2);
            switch (a.D) {
                case 4:
                    return a.w ? (e = Math.floor(.3 * c), f = Math.floor(.3 * d), [new K(e, f), new K(c - e, f), new K(e, d - f), new K(c - e, d - f)]) : [new K(e, 0), new K(0, f), new K(e, d - 1), new K(c - 1, f)];
                case 3:
                    return [new K(c - 1, 0), new K(e, f), new K(0, d - 1)];
                default:
                    return [new K(e, f)]
            }
        },
        Of = function(a, b) {
            var c;
            try {
                c = b || a.l.getBoundingClientRect()
            } catch (d) {
                c = new Sd(0, 0, 0, 0)
            }
            var e = Nf(a, c);
            E(e, function(a) {
                a.x += c.left;
                a.y += c.top
            });
            return e
        },
        Pf = function(a, b, c, d) {
            Mf.call(this, a, d);
            this.A = b || 3E3;
            this.B = c || 3E3;
            this.g = "u";
            this.b = [];
            this.o = !1;
            this.h = -1;
            this.j = this.m = 0;
            this.w = a
        };
    A(Pf, Mf);
    var Qf = function(a, b, c) {
            this.b = a;
            this.h = b;
            this.g = c
        },
        Tf = function(a, b, c) {
            if (!(b && b.getBoundingClientRect && 0 <= xa(lf, "11") && c) || I && 9 > nc || 0 < a.b.length) return !1;
            try {
                var d = b.getBoundingClientRect()
            } catch (e) {
                return !1
            }
            var f = "DIV" == b.tagName || "INS" == b.tagName,
                g = bd(b),
                k = [];
            if (f) {
                var m = Jf(),
                    d = Nf(a, d);
                E(d, function(a, b) {
                    var d = new Rf("e", g, c, String(b));
                    this.b.push(d);
                    k.push(z(d.A, d, m, a))
                }, a);
                b.insertBefore(m, b.childNodes[0] || null)
            } else d = Of(a, d), E(d, function(a, d) {
                var e = new Rf("e", g, c, String(d));
                this.b.push(e);
                k.push(z(e.D,
                    e, b, a))
            }, a);
            var p = !0;
            E(k, function(a) {
                p = p && a()
            });
            p ? (a.g = "l", a.l = b, a.o = !f) : (E(a.b, function(a) {
                Sf(a)
            }), a.b = []);
            return p
        },
        Vf = function(a) {
            if (a.l && a.o) {
                var b = Of(a);
                E(b, function(a, b) {
                    this.b[b] && Uf(this.b[b], a)
                }, a)
            }
        },
        Wf = function(a) {
            E(a.b, function(a) {
                Sf(a)
            });
            a.b = [];
            a.g = "d"
        },
        bg = function(a) {
            var b = ia(),
                c = a.m ? b - a.m : 0,
                d = -1,
                e = nb(a.b, function(a) {
                    return Xf(a, b)
                });
            4 == a.b.length ? d = a.w ? Yf(e) : Zf(e) : 3 == a.b.length ? d = $f(e) : 1 == a.b.length && (d = [-1, 0, 1, 2, 3, 5][Xf(a.b[0], b) + 1]);
            a.j = d == a.h ? a.j + c : 0;
            c = new Qf(d, a.h, c);
            a.h = d;
            a.m = b;
            ag(a, d);
            Vf(a);
            return c
        },
        dg = function(a) {
            var b = yb(Hb(cg));
            E(a, function(a) {
                0 <= a && ++b[a]
            });
            return b
        },
        Zf = function(a) {
            a = dg(a);
            return 4 == a[4] ? 6 : 3 <= a[4] ? 5 : 0 < a[4] ? 4 : 4 == a[2] ? 2 : 4 == a[1] ? 1 : 4 == a[0] ? 0 : 3
        },
        $f = function(a) {
            var b = dg(a);
            return 4 == a[0] && 4 == a[2] ? 6 : 4 == a[1] ? 5 : 0 < b[4] ? 4 : 3 == b[2] ? 2 : 3 == b[1] ? 1 : 3 == b[0] ? 0 : 3
        },
        Yf = function(a) {
            a = dg(a);
            return 3 <= a[4] ? 5 : 2 == a[4] ? 8 : 0 < a[4] ? 7 : 4 == a[2] ? 2 : 4 == a[1] ? 1 : 4 == a[0] ? 0 : 3
        },
        ag = function(a, b) {
            0 == b && eg(a) ? a.g = "n" : a.g = "dlfcrrrr".split("")[b + 1]
        },
        eg = function(a) {
            return "n" == a.g ? !0 : "l" == a.g && a.j >=
                a.B
        },
        Rf = function(a, b, c, d) {
            this.b = null;
            this.j = a;
            this.m = "e" == a ? String(c) + "~" + String(d) : "";
            this.g = [];
            this.h = -1;
            this.w = 0;
            this.l = yb(Hb(fg));
            this.B = yb(Hb(cg));
            "e" == this.j && (gg[this.m] = z(this.o, this));
            I ? (a = b.createElement("div"), a.innerHTML = '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" style="opacity:0;-ms-filter:\'progid:DXImageTransform.Microsoft.Alpha(opacity=0)\';filter:alpha(opacity=0)"><param name="movie" value="' + hg(this, !0) + '"></param><param name="allowscriptaccess" value="always"></param><param name="wmode" value="transparent"></param></object>',
                a = a.firstChild, a.id = String(Math.random())) : a = ig(this, b);
            a.width = 1;
            a.height = 1;
            a.style.zIndex = -999999;
            this.b = a
        },
        cg = {
            Mf: -1,
            LOADING: 0,
            Mc: 1,
            Jc: 2,
            df: 3,
            VISIBLE: 4
        },
        fg = {
            LOADING: 0,
            Mc: 1,
            Jc: 2,
            If: 3,
            pf: 4,
            Kf: 5,
            Lf: 6,
            Jf: 7,
            rf: 8,
            Hf: 9
        },
        gg = {},
        ig = function(a, b) {
            var c = function(a, c, d) {
                    var e = b.createElement("param");
                    e.name = c;
                    e.value = d;
                    a.appendChild(e)
                },
                d = hg(a),
                e = b.createElement("object");
            e.type = "application/x-shockwave-flash";
            e.data = d;
            c(e, "movie", d);
            c(e, "allowscriptaccess", "always");
            c(e, "wmode", "opaque");
            e.style.visibility =
                "s" == a.j ? "" : "hidden";
            e.style.opacity = 0;
            return e
        },
        hg = function(a, b) {
            var c = "//pagead2.googlesyndication.com/osd/hbt.swf";
            "s" == a.j && (c = "//pagead2.googlesyndication.com/osd/hbts.swf");
            "e" == a.j && (c = zc("//pagead2.googlesyndication.com/osd/hbe.swf", "id", a.m));
            b && (c = zc(c, "delay", "1"));
            return c
        };
    Rf.prototype.A = function(a, b) {
        if (!this.b) return !1;
        this.b.style.position = "absolute";
        Uf(this, b);
        var c = !0;
        try {
            a.appendChild(this.b)
        } catch (d) {
            c = !1
        }
        return c
    };
    Rf.prototype.D = function(a, b) {
        if (!this.b || !a.parentNode) return !1;
        this.b.style.position = "fixed";
        Uf(this, b);
        var c = !0;
        try {
            a.parentNode && a.parentNode.insertBefore(this.b, a.nextSibling)
        } catch (d) {
            c = !1
        }
        return c
    };
    var Uf = function(a, b) {
            var c;
            if (c = a.b) c = a.b, c = new K(c.offsetLeft, c.offsetTop), c = !(b == c || b && c && b.x == c.x && b.y == c.y);
            if (c) {
                c = a.b;
                var d, e;
                b instanceof K ? (d = b.x, e = b.y) : (d = b, e = void 0);
                c.style.left = Zd(d);
                c.style.top = Zd(e)
            }
        },
        Sf = function(a) {
            if (a.b) try {
                ld(a.b)
            } catch (b) {}
            a.b = null
        };
    Rf.prototype.o = function(a) {
        this.h = a ? 3 : 4
    };
    var Xf = function(a, b) {
            if ("e" == a.j) {
                var c = null;
                try {
                    c = a.b.it()
                } catch (d) {}
                null === c ? (c = 0, 0 < a.h && (c = 2)) : c = c ? 3 : 4;
                ++a.B[c + 1];
                a.h = c
            } else {
                var e = Number(b),
                    f, c = null;
                try {
                    c = a.b.fc()
                } catch (g) {}
                f = c;
                jg(a, f, e);
                c = a.g[a.g.length - 1];
                if (null === f) {
                    if (f = e = 0, 0 < a.h || x(c.Ya)) f = e = 2
                } else null === c.Ya || c.xb >= e ? (e = 10 <= f ? 4 : 0, f = 0) : f > c.Ya ? (c = (f - c.Ya) / (e - c.xb) * 1E3, e = 10 <= c ? 4 : 3, c = 0 == c ? 1 : 1 > c ? 3 : 4 > c ? 4 : 23 > c ? 6 : 26 > c ? 8 : 9, 6 == a.w && 6 == c && (c = 7), f = c) : f = e = 1;
                6 == a.w && (--a.l[6], 4 == f || 8 == f ? ++a.l[5] : ++a.l[7]);
                ++a.l[f];
                a.h = e;
                a.w = f
            }
            return a.h
        },
        jg = function(a,
            b, c) {
            var d = c - 1E3,
                e = a.g.length;
            E(a.g, function(a, b) {
                a.xb <= d && (e = Math.min(e, b + 1))
            });
            var f = a.g.length - e;
            0 < f && a.g.splice(e, f);
            a.g.unshift({
                Ya: b,
                xb: c
            })
        };
    r("gteh", cb("osd_or_lidar::gteh_ex", function(a, b) {
        var c = gg[a];
        y(c) && c(b)
    }), void 0);
    var kg = function() {
            this.h = !1;
            this.g = void 0;
            this.b = !Da(C.top)
        },
        lg = null,
        Af = function() {
            lg || (lg = new kg);
            return lg
        };
    var qg = function(a, b, c, d, e) {
            this.b = mg.clone();
            this.o = this.L = 0;
            this.Cb = this.Db = this.ka = -1;
            this.na = [0, 0, 0, 0, 0];
            this.O = [0, 0, 0, 0, 0];
            this.B = [0, 0, 0, 0, 0];
            this.Ga = 0;
            this.Bb = [0, 0, 0, 0, 0];
            this.Ab = [0, 0, 0, 0, 0];
            this.ja = [0, 0, 0, 0, 0];
            this.ub = this.aa = 0;
            this.D = {};
            this.Eb = {};
            this.Ca = [0, 0, 0, 0, 0];
            this.J = d;
            this.$ = this.V = -1;
            this.qb = b;
            this.l = e;
            this.Ra = function() {};
            this.Wb = function() {};
            this.F = this.h = c;
            this.Jb = 0;
            this.ad = -1;
            this.w = "";
            this.tb = c ? String(c._avi_ || "") : "";
            this.j = null;
            this.K = 1;
            this.ia = !1;
            this.I = this.G = this.Ib = null;
            this.Ha = 0;
            this.Fa = !1;
            this.da = null;
            this.Lb = this.Ja = this.Ia = !1;
            this.bd = .01 > Math.random();
            this.Vb = null;
            this.Xb = !1;
            this.Va = [];
            this.ta = void 0;
            this.Hb = this.gb = this.$b = this.ua = !1;
            this.m = void 0;
            this.ab = 0;
            this.oa = -1;
            this.zb = this.ca = 0;
            this.La = void 0;
            this.$a = !1;
            this.ga = -1;
            this.wb = void 0;
            this.Ua = this.T = 0;
            this.fb = -1;
            this.cb = !1;
            this.ba = this.Gb = this.sb = 0;
            this.Fb = !1;
            this.g = 0;
            this.Qb = this.Rb = this.bb = !1;
            this.Tb = 0;
            this.Zb = this.Kb = this.N = !1;
            this.Ub = 0;
            this.Sa = !0;
            this.Ta = 0;
            this.vb = 3 == this.l ? Ea() || 0 : 0;
            this.yb = 0;
            this.Nb =
                this.Pb = this.Mb = !1;
            ng(this, c && c._avm_);
            og(this);
            b = Af();
            pg(this, a, b.b)
        },
        mg = new Sd(0, 0, 0, 0),
        ng = function(a, b) {
            if (w(b) && 0 != b.length)
                for (var c = b.split("&"), d = 0; d < c.length; d++) {
                    var e = c[d],
                        f = Ze,
                        g = $e;
                    e != f.Zc && (e == f.Vc ? a.Sa = !1 : e == f.Oc ? (e = C, 5 == a.l && e.osdpcls && y(e.osdpcls) && e.osdpcls(a.tb)) : 0 == e.lastIndexOf(g.Nc, 0) && (e = e.split("=")[1], "0" == e ? a.yb = 2 : "1" == e && (a.yb = 1)))
                }
        },
        og = function(a) {
            if (a.qb && w(a.qb)) {
                var b = a.qb.match(/loeid=([^&;]+)/);
                if (b && 2 == b.length) {
                    var b = b[1],
                        c = jb.Tc,
                        d = jb.Sc;
                    b.match(jb.Rc.R) ? a.Mb = !0 : b.match(c.R) ?
                        a.Pb = !0 : b.match(d.R) && (a.Nb = !0)
                }
            }
        },
        sg = function(a, b, c, d, e) {
            if (!(0 > a.J)) {
                var f = C.innerWidth,
                    g = C.innerHeight,
                    k = new Sd(Math.round(C.mozInnerScreenY), Math.round(C.mozInnerScreenX + f), Math.round(C.mozInnerScreenY + g), Math.round(C.mozInnerScreenX));
                c = new Sd(C.screenY + d, C.screenX + c.width, C.screenY + c.height, C.screenX);
                e || (d = new Sd(k.top - c.top, k.right - c.left, k.bottom - c.top, k.left - c.left), d.top > a.b.top ? a.b = d : (a.b.right = a.b.left + f, a.b.bottom = a.b.top + g), a.L = f * g);
                rg(a, k, c, b, e, !0)
            }
        },
        vg = function(a, b, c) {
            var d = Lf(C &&
                C.document);
            if (d) {
                c || pg(a, C, !0);
                if (tg(a) || a.$a) d = ug(a, d);
                else var e = Math.floor((a.b.left + a.b.right) / 2),
                    f = Math.floor((a.b.top + a.b.bottom) / 2),
                    g = hd(document),
                    d = d(e - g.x, f - g.y) ? .5 : 0;
                rg(a, a.b, d, b, c, !0)
            }
        },
        wg = function(a, b, c) {
            var d;
            if (c(b)) return b;
            for (;;) {
                d = Math.floor((a + b) / 2);
                if (d == a || d == b) return a;
                c(d) ? a = d : b = d
            }
        },
        ug = function(a, b) {
            var c = hd(document),
                d = function(a, c) {
                    return Boolean(b(a, c))
                },
                e = Math.floor(a.b.left - c.x),
                f = Math.floor(a.b.top - c.y),
                g = Math.floor(a.b.right - c.x),
                k = Math.floor(a.b.bottom - c.y),
                c = d(e, f),
                m = d(g, k);
            if (c && m) return 1;
            var p = d(g, f),
                t = d(e, k);
            if (c) k = wg(f, k, function(a) {
                return d(e, a)
            }), g = wg(e, g, function(a) {
                return d(a, f)
            });
            else if (p) k = wg(f, k, function(a) {
                return d(g, a)
            }), e = wg(g, e, function(a) {
                return d(a, f)
            });
            else if (t) f = wg(k, f, function(a) {
                return d(e, a)
            }), g = wg(e, g, function(a) {
                return d(a, k)
            });
            else if (m) f = wg(k, f, function(a) {
                return d(g, a)
            }), e = wg(g, e, function(a) {
                return d(a, k)
            });
            else {
                var D = Math.floor((e + g) / 2),
                    q = Math.floor((f + k) / 2);
                if (!d(D, q)) return 0;
                f = wg(q, f, function(a) {
                    return d(D, a)
                });
                k = wg(q, k, function(a) {
                    return d(D,
                        a)
                });
                e = wg(D, e, function(a) {
                    return d(a, q)
                });
                g = wg(D, g, function(a) {
                    return d(a, q)
                })
            }
            return (k - f) * (g - e) / a.L
        },
        xg = function(a, b, c, d, e) {
            0 > a.J || (d || pg(a, C, e), Boolean(null) && d && (C.clearInterval(a.Ib), a.Ib = null), null != a.da && (d ? (C.clearInterval(a.I), a.I = null, a.Fa = !1) : a.Ia && !a.I && (a.I = C.setInterval(db("osd_or_lidar::adblock::iem_int", z(a.Yb, a, C, 1E3)), 1E3), a.Yb(C))), rg(a, a.b, c, b, d, !1))
        },
        rg = function(a, b, c, d, e, f) {
            var g, k = d - a.J || 1;
            if (!g) {
                var m = {};
                if ("as" == a.m && y(a.h.getVideoMetadata)) try {
                    m = a.h.getVideoMetadata()
                } catch (p) {
                    a.bb = !0
                }
                if ("h" == a.m && (g = aa("ima.common.getVideoMetadata"), y(g))) try {
                    m = g(a.w)
                } catch (t) {
                    a.bb = !0
                }
                g = m.currentTime;
                n(g) ? m.currentTime = Math.floor(1E3 * g) : a.Qb = !0;
                g = m.duration;
                n(g) && (m.duration = Math.floor(1E3 * g));
                n(m.volume) || (m.volume = yg(a));
                g = m
            }
            a.ga = g.duration || a.ga;
            a.wb = g.isVpaid || a.wb;
            m = g.volume;
            g = n(g.currentTime) ? g.currentTime : a.T + k;
            g < a.T && (g = a.T, a.Rb = !0);
            var D = g - a.T,
                q = null;
            x(c) ? b = zg(a, c) : (q = c, b = zg(a, b, q));
            a.ta || Ag(a, b, k, a.V, f, e, q, m, D);
            a.V = e ? -1 : b;
            a.J = d;
            a.T = g; - 1 != b && (0 > a.ka && (a.ka = d), a.Cb = d); - 1 == a.Db && Bg(a) &&
                (a.Db = d);
            a.Ra(a, q || mg)
        },
        zg = function(a, b, c) {
            if (a.Kb) return a.o = 0, Cg(a.o);
            if (a.N && 7 == a.l) return a.o = 1, Cg(a.o);
            var d = null;
            if (x(b)) a.o = b;
            else {
                c = new Sd(Math.max(b.top, c.top), Math.min(b.right, c.right), Math.min(b.bottom, c.bottom), Math.max(b.left, c.left));
                if (0 >= a.L || c.top >= c.bottom || c.left >= c.right) return a.o = 0, -1;
                var d = c.clone(),
                    e = -b.left;
                b = -b.top;
                e instanceof K ? (d.left += e.x, d.right += e.x, d.top += e.y, d.bottom += e.y) : (d.left += e, d.right += e, x(b) && (d.top += b, d.bottom += b));
                d = (c.bottom - c.top) * (c.right - c.left);
                a.o =
                    d / a.L
            }
            return Cg(a.o)
        },
        Cg = function(a) {
            var b = -1;
            1 <= a ? b = 0 : .75 <= a ? b = 1 : .5 <= a ? b = 2 : .3 <= a ? b = 3 : 0 < a && (b = 4);
            return b
        },
        tg = function(a) {
            return 7 == a.l || !(!Af().b || Dg && a.Mb || Eg && a.Pb || Boolean(a.j) && a.Nb) || a.Ia ? !1 : 1 == a.yb
        },
        Ag = function(a, b, c, d, e, f, g, k, m) {
            e = e && -1 != d && d <= (tg(a) ? 3 : 2);
            var p = -1 == d || -1 == b ? -1 : Math.max(d, b);
            d = e ? p : d;
            m = m || 0; - 1 != d && (a.na[d] += c, a.Bb[d] += m, d <= (tg(a) ? 3 : 2) && (a.Ga += c, a.aa += m));
            g = g || null;
            e = -1 != d && d <= (tg(a) ? 3 : 2);
            g ? (e && -1 != a.$ && (a.Ca[a.$] += c), g = 100 * a.L / ((g.bottom - g.top) * (g.right - g.left)), a.$ = 20 <= g ? 0 :
                10 <= g ? 1 : 5 <= g ? 2 : 2.5 <= g ? 3 : 4) : a.$ = -1;
            if (7 == a.l) {
                g = -1 != d && 2 >= d;
                e = n(k) && .1 <= k && .1 <= a.La;
                e && 0 == d || (a.Fb = !1);
                a.Ua += c;
                e && (a.sb += c, 0 == d && (a.ba += c), g ? a.Gb += c : a.ca += c);
                a.ca > a.zb && (a.zb = a.ca);
                if (g || !n(k) || .1 > k) a.ca = 0;
                n(k) && (Number(k) ? (g = Math.pow(10, 3), k = Math.round(k * g) / g) : k = 0);
                a.La = k
            }
            for (k = d; 0 <= k && 4 >= k; k++) a.B[k] += c, a.ja[k] += m, a.B[k] > a.O[k] && (a.O[k] = a.B[k]), a.ja[k] >= a.Ab[k] && (a.Ab[k] = a.ja[k]);
            for (k = 0; k < a.B.length; ++k)
                if (k < b || f || -1 == b) a.B[k] = 0, a.ja[k] = 0
        },
        Fg = function(a, b, c, d) {
            var e = tg(a);
            a.K = c;
            e && (a.K = 4);
            if (!Boolean(Boolean(a.F &&
                !!d && !(hc && rf && 0 <= xa(tf, "6.0.1") && 0 <= xa(lf, "10.1"))) && !(hc && rf && 0 <= xa(tf, "6.0.1") && 0 <= xa(lf, "10.1")))) return a.ia = !0, !1;
            c = new Pf(e, void 0, void 0, a.K);
            (d = Tf(c, a.F, d)) ? (a.Wb = b, a.j = c) : a.ia = !0;
            return d
        };
    qg.prototype.Yb = function(a, b) {
        var c = Lf(a && a.document);
        if (c) {
            pg(this, a, !0);
            if (tg(this)) c = ug(this, c) >= (tg(this) ? .3 : .5);
            else var d = Math.floor((this.b.left + this.b.right) / 2),
                e = Math.floor((this.b.top + this.b.bottom) / 2),
                f = hd(document),
                c = Boolean(c(d - f.x, e - f.y));
            d = b || 0;
            c ? (this.Ha += this.Fa ? d : 0, this.Fa = !0) : (this.Ha = 0, this.Fa = !1);
            1E3 <= this.Ha && (a.clearInterval(this.I), this.I = null, this.Ia = !1, this.da = "v");
            pg(this, a, !1)
        } else a.clearInterval(this.I), this.I = null, this.Ia = !1, this.da = "i"
    };
    var Gg = function(a, b, c) {
        if (!(0 > a.J || null === a.G)) {
            c ? a.G && a.G.b() : (pg(a, C, !0), a.G && a.G.g());
            var d = 0;
            x(void 0) || (d = 2 == a.V ? .5 : 0);
            rg(a, a.b, d, b, c, !1);
            Bg(a) && 7 != a.l && !a.Sa && a.G && (a.G.h(), a.G = null)
        }
    };
    qg.prototype.A = function() {
        var a = this.b,
            a = ["p:", a.top, a.left, a.bottom, a.right];
        a.push("tos:", this.na.join(","));
        a.push("mtos:", this.O.join(","));
        a.push("rs:", this.l);
        5 !== this.l && 6 !== this.l && (a.push("zoom:", this.Ca.join(",")), a.push("ht:", this.Jb));
        0 <= this.ka && a.push("tfs:", this.ka, "tls:", this.Cb);
        a.push("vt:", this.Db);
        7 == this.l && a.push("qid:", this.w);
        this.tb && a.push("avi:", this.tb);
        this.da && a.push("iemv:", this.da);
        this.G && a.push("sfm:1");
        this.j ? (a.push("swf:", this.j.g), a.push("px:", String(this.K))) :
            this.ia && (a.push("swf:", "-"), a.push("px:", String(this.K)));
        tg(this) && a.push("la:", "1");
        return a.join(",")
    };
    var pg = function(a, b, c) {
            a.Ta++;
            b = c ? b : b.top;
            try {
                var d = mg.clone(),
                    e = new K(0, 0);
                if (a.F) {
                    if (c || 1 != a.l || !Kf(a.F)) d = a.F.getBoundingClientRect();
                    if (c || !b.frameElement) e = Yd(a.F, b)
                }
                var f = e.x,
                    g = e.y,
                    k = d.right - d.left,
                    m = d.bottom - d.top;
                a.b = new Sd(Math.round(g), Math.round(f + k), Math.round(g + m), Math.round(f))
            } catch (p) {
                a.b = mg.clone()
            }
            a.L = (a.b.bottom - a.b.top) * (a.b.right - a.b.left);
            2 != a.l && 3 != a.l && 6 != a.l || 0 != a.L ? (a.Lb = !1, a.Vb = null) : 3 == a.l && (2 == a.vb && 2 >= a.Ta || 3 == a.vb && 4 >= a.Ta || 4 == a.vb && 8 >= a.Ta) || (a.Lb = !0, a.F && a.F.parentElement &&
                a.bd && (c = a.F.parentElement.getBoundingClientRect(), a.Vb = new Sd(c.top, c.right, c.bottom, c.left)))
        },
        Bg = function(a) {
            var b = tg(a) ? 3 : 2;
            return 1E3 <= Math.max(a.B[b], a.O[b])
        },
        Hg = function(a) {
            return 2E3 <= Math.max(a.B[2], a.O[2])
        },
        Ig = function(a, b) {
            var c = a.ab;
            Df || a.ta || -1 == a.oa || (c += b - a.oa);
            return c
        },
        yg = function(a) {
            if ("as" == a.m && y(a.h.sdkVolume)) try {
                return Number(a.h.sdkVolume())
            } catch (b) {
                return -1
            }
            if ("h" == a.m) {
                var c = aa("ima.common.sdkVolume");
                if (y(c)) try {
                    return Number(c(a.w))
                } catch (d) {
                    return -1
                }
            }
        },
        Jg = function(a,
            b) {
            wb(a.Va, yb(b - a.Va.length + 1));
            a.Va[b] = (100 * a.o | 0) / 100
        },
        T = function(a, b) {
            var c = a.Eb[b];
            if (null != c) return c;
            if (a.Ja) return {
                "if": 0
            };
            c = a.b.clone();
            c.round();
            var d = nb(a.Va, function(a) {
                    return 100 * a | 0
                }),
                c = {
                    "if": Af().b ? 1 : void 0,
                    sdk: a.m ? a.m : void 0,
                    p: [c.top, c.left, c.bottom, c.right],
                    tos: a.na,
                    mtos: a.O,
                    ps: void 0,
                    pt: d,
                    vht: Ig(a, Cf()),
                    mut: a.zb,
                    a: a.La,
                    ns: a.Ub,
                    at: a.sb,
                    afvt: a.ba,
                    vpt: a.Ua
                };
            a.$a && (c.efpf = 1);
            a.j && (c.swf = a.j.g, c.px = a.K);
            0 < a.Tb && (c.nnut = a.Tb);
            7 == a.l && (c.vme = a.bb ? 1 : 0, c.nmtd = a.Rb ? 1 : 0, c.mmct = a.Qb ? 1 : 0, c.vpaid =
                a.wb, c.dur = a.ga, c.vmtime = a.T, c.vmtos = a.Bb, c.vmmtos = a.Ab);
            Kg(a, b) && Hg(a) && 7 == a.l && (c.dtos = a.Ga, c.vmdtos = a.aa, a.ub++, c.dtoss = a.ub, a.Ga = 0, a.aa = 0);
            !Hg(a) && 2E3 <= a.aa && (c.vmdtos = a.aa);
            Lg && (c.ps = [Lg.width, Lg.height]);
            a.ia && (c.fmf = "1", c.px = a.K);
            a.ua && (c.ven = "1");
            a.$b && (c.veh = "1");
            a.g && (c.vds = a.g);
            Mg() ? c.c = (100 * a.o | 0) / 100 : c.tth = Cf() - zf;
            return c
        },
        Kg = function(a, b) {
            var c = a.D[b];
            return n(c) && (a.D[b] = !0, !c) ? !0 : !1
        };
    var Ng = function(a, b, c) {
        wd.call(this);
        this.j = a;
        this.h = b;
        this.g = c;
        this.b = z(this.Ge, this)
    };
    A(Ng, wd);
    h = Ng.prototype;
    h.Wa = !1;
    h.qa = null;
    h.dc = function() {
        this.qa ? this.Wa = !0 : Og(this)
    };
    h.H = function() {
        Ng.X.H.call(this);
        this.qa && (l.clearTimeout(this.qa), this.qa = null, this.Wa = !1)
    };
    h.Ge = function() {
        this.qa = null;
        this.Wa && (this.Wa = !1, Og(this))
    };
    var Og = function(a) {
        a.qa = Se(a.b, a.h);
        a.j.call(a.g)
    };
    var Pg = function() {
        return H("iPad") || H("Android") && !H("Mobile") || H("Silk")
    };
    var Qg = null,
        Rg = null,
        Sg = null,
        Tg = null,
        Ug = null,
        Vg = !1,
        $g = function() {
            if (!Vg) {
                Vg = !0;
                var a = l.requestAnimationFrame || l.webkitRequestAnimationFrame || l.mozRequestAnimationFrame || l.oRequestAnimationFrame || l.msRequestAnimationFrame;
                if (!Qg) {
                    var b;
                    if (a) {
                        var c = cb("osd_or_lidar::throttled_scroll_raf_callback", Wg);
                        b = function() {
                            a(function() {
                                C.setTimeout(c, 0)
                            })
                        }
                    } else b = Wg;
                    Rg = new Ng(cb("osd_or_lidar::throttled_scroll_timeout", b), 100);
                    b = z(Rg.dc, Rg);
                    Qg = vf(C, "scroll", b, "osd_or_lidar::throttled_scroll")
                }
                if (!Sg) {
                    if (a) {
                        var d =
                            cb("osd_or_lidar::throttled_resize_raf_callback", Xg);
                        b = function() {
                            a(function() {
                                C.setTimeout(d, 0)
                            })
                        }
                    } else b = Xg;
                    Tg = new Ng(cb("osd_or_lidar::throttled_resize_timeout", b), 100);
                    b = z(Tg.dc, Tg);
                    Sg = vf(C, "resize", b, "osd_or_lidar::throttled_resize")
                }
                Yg();
                Zg()
            }
        },
        Xg = function() {
            ah(!1);
            Wg()
        },
        Wg = function() {
            bh(U, !1)
        },
        jh = function() {
            var a;
            ch && (dh = yf(C, ch));
            a = dh;
            var b = eh,
                c = Dg;
            if (Eg) {
                a = b;
                ah(!1);
                var d = fh,
                    e = d.height - a;
                0 >= e && (e = d.height, a = 0);
                dh = new L(d.width, e);
                e = new gh;
                e.w = !0;
                e.j = dh;
                e.h = d;
                e.g = a;
                return e
            }
            if (c) return a = new gh,
                a.l = !0, a;
            if (hh) return a = new gh, a.m = !0, a;
            if (ih) return a = new gh, a.o = !0, a;
            a: {
                b = new gh;
                b.j = a;
                b.b = !1;
                if (null != a && -1 != a.width && -1 != a.height && -12245933 != a.width && -12245933 != a.height) {
                    try {
                        var c = ch,
                            f = C || C,
                            f = f.top,
                            e = a || yf(f, c),
                            g = rd(cd(f.document)),
                            d = -1 == e.width || -12245933 == e.width ? new Sd(e.width, e.width, e.width, e.width) : new Sd(g.y, g.x + e.width, g.y + e.height, g.x)
                    } catch (k) {
                        a = b;
                        break a
                    }
                    b.D = d;
                    b.b = !0
                }
                a = b
            }
            return a
        },
        bh = function(a, b) {
            var c;
            if (!kh)
                if (window.clearTimeout(lh), lh = null, 0 == a.length) b || mh();
                else {
                    var d = jh();
                    try {
                        var e = Cf();
                        if (d.w)
                            for (c = 0; c < a.length; c++) sg(a[c], e, d.h, d.g, b);
                        else if (d.l)
                            for (c = 0; c < a.length; c++) vg(a[c], e, b);
                        else if (d.m) E(a, function(a) {
                            if (b) {
                                if (a.j) {
                                    var c = a.j;
                                    3 <= c.h && (c.h = 3);
                                    a.V = -1
                                }
                            } else if (a.j && "d" != a.j.g) {
                                var c = bg(a.j),
                                    d = [-1, -1, -1, -1, -1, 4, 2, 0],
                                    e = d[c.b + 1];
                                Ag(a, e, c.g, d[c.h + 1], !0, !1);
                                a.V = e;
                                a.Ra(a, mg);
                                Bg(a) && 7 != a.l && !a.Sa && a.j && Wf(a.j);
                                (c = 2 == c.b || eg(a.j)) || (c = a.j, c = "f" == c.g && c.j >= c.A);
                                c && (a.Wb(a), a.Sa = !1, a.j && Wf(a.j))
                            }
                        });
                        else if (d.o)
                            for (c = 0; c < a.length; c++) Gg(a[c], e, b);
                        else if (d.b) {
                            var f = Af();
                            for (c = 0; c < a.length; c++) xg(a[c], e, d.D, b, f.b)
                        }++nh
                    } finally {
                        b ? E(a, function(a) {
                            a.o = 0
                        }) : mh()
                    }
                }
        },
        Yg = function() {
            var a = Zg,
                b;
            Ga.mozVisibilityState ? b = "mozvisibilitychange" : Ga.webkitVisibilityState ? b = "webkitvisibilitychange" : Ga.visibilityState && (b = "visibilitychange");
            b && (Ug = Ug || vf(Ga, b, a, "osd_or_lidar::visibility"))
        },
        Zg = function() {
            var a = Mg();
            if (a) {
                if (!Df) {
                    var b = Cf();
                    Ef = b;
                    E(U, function(a) {
                        a.ab = Ig(a, b)
                    })
                }
                Df = !0;
                ah(!0)
            } else b = Cf(), Df = !1, zf = b, E(U, function(a) {
                0 <= a.J && (a.oa = b)
            });
            bh(U, !a)
        },
        Mg = function() {
            if (oh()) return !0;
            var a;
            a = C.document;
            a = {
                visible: 1,
                hidden: 2,
                prerender: 3,
                preview: 4
            }[a.webkitVisibilityState || a.mozVisibilityState || a.visibilityState || ""] || 0;
            return 1 == a || 0 == a
        },
        mh = function() {
            C && (lh = C.setTimeout(db("osd_or_lidar::psamp_to", function() {
                bh(U, !1)
            }), Gf()))
        },
        ph = function(a) {
            return null != qb(U, function(b) {
                return b.h == a
            })
        },
        U = [],
        kh = !1,
        dh = null,
        fh = null,
        Lg = null,
        lh = null,
        eh = 0,
        Eg = !1,
        Dg = !1,
        hh = !1,
        ih = !1,
        ch = Pg() || !Pg() && (H("iPod") || H("iPhone") || H("Android") || H("IEMobile")),
        nh = 0,
        qh = function() {
            var a = C.document;
            return a.body &&
                a.body.getBoundingClientRect ? !0 : !1
        },
        ah = function(a) {
            dh = yf(C, ch);
            if (!a) {
                fh = C.outerWidth ? new L(C.outerWidth, C.outerHeight) : new L(-12245933, -12245933);
                a = C;
                a.top != a && (a = a.top);
                var b = 0,
                    c = 0,
                    d = dh;
                try {
                    var e = a.document,
                        f = e.body,
                        g = e.documentElement;
                    if ("CSS1Compat" == e.compatMode && g.scrollHeight) b = g.scrollHeight != d.height ? g.scrollHeight : g.offsetHeight, c = g.scrollWidth != d.width ? g.scrollWidth : g.offsetWidth;
                    else {
                        var k = g.scrollHeight,
                            m = g.scrollWidth,
                            p = g.offsetHeight,
                            t = g.offsetWidth;
                        g.clientHeight != p && (k = f.scrollHeight,
                            m = f.scrollWidth, p = f.offsetHeight, t = f.offsetWidth);
                        k > d.height ? k > p ? (b = k, c = m) : (b = p, c = t) : k < p ? (b = k, c = m) : (b = p, c = t)
                    }
                    Lg = new L(c, b)
                } catch (D) {
                    Lg = new L(-12245933, -12245933)
                }
            }
        },
        sh = function() {
            var a = rh,
                b = !1;
            E(U, function(c, d) {
                var e = Fg(c, a, n(.1) && .1 > Math.random() ? 3 : 1, String(d));
                b = b || e
            });
            (hh = b) && E(U, function(b) {
                Boolean(b.j) || a(b)
            });
            return b
        },
        th = function(a) {
            E(a, function(a) {
                ph(a.h) || U.push(a)
            })
        },
        oh = function() {
            return ob(U, function(a) {
                return a.N
            })
        },
        gh = function() {
            this.h = this.j = null;
            this.g = 0;
            this.D = null;
            this.b = this.o = this.m =
                this.l = this.w = !1
        };
    var uh = function(a, b) {
            this.b = a;
            this.g = b
        },
        vh = function(a, b) {
            this.url = a;
            this.Za = b;
            this.xc = !1;
            this.depth = x(void 0) ? void 0 : null
        },
        wh = function() {
            var a = l,
                b = [],
                c = null,
                d = null;
            do {
                var e = a;
                Da(e) ? (c = e.location.href, d = e.document.referrer || null) : (c = d, d = null);
                b.push(new vh(c, e));
                try {
                    a = e.parent
                } catch (f) {
                    a = null
                }
            } while (a && e != a);
            e = 0;
            for (a = b.length - 1; e <= a; ++e) b[e].depth = a - e;
            e = l;
            if ((a = e.location.ancestorOrigins) && a.length == b.length - 1)
                for (e = 1; e < b.length; ++e) c = b[e], c.url || (c.url = a[e - 1], c.xc = !0);
            return b
        };
    var xh = function(a, b, c) {
        b = b || ",|";
        "string" == typeof b && (b = b.split(""));
        c = c || 0;
        if (!(a instanceof Array) || c >= b.length) return encodeURIComponent("" + a);
        for (var d = [], e = 0; e < a.length; e++) d.push(xh(a[e], b, c + 1));
        return d.join(b[c])
    };
    var zh = function() {
            var a = wh(),
                b = a.length - 1,
                c, a = a ? a : wh();
            c = a.length - 1;
            for (var d = null, e = c; 0 <= e; --e) {
                var f = a[e];
                if (f.url && !f.xc) {
                    d = f;
                    break
                }
            }
            e = null;
            f = a.length && a[c].url;
            d && 0 == d.depth || !f || (e = a[c]);
            c = new uh(d, e);
            a = c.b;
            d = c.g;
            c = [];
            d ? (a && c.push(yh(b, [d.url, 2], 0, [a.url, 0], a.depth)), c.push(yh(b, [d.url, 2], 0))) : a && a.url && (c.push(yh(b, void 0, void 0, [a.url, 0], a.depth)), (d = (d = Fa.exec(a.url)) && d[0] || "") && c.push(yh(b, [d, 1], a.depth)));
            c.push(yh(b));
            return c
        },
        yh = function(a, b, c, d, e) {
            a = [a];
            if (n(b) && n(c)) {
                for (var f = 0; f <
                    c; f++) a.push("");
                a.push(b)
            }
            if (n(d) && n(e)) {
                b = e - a.length + 1;
                for (f = 0; f < b; f++) a.push("");
                a.push(d)
            }
            return a
        },
        Ah = function() {
            var a = zh();
            return nb(a, function(a) {
                return xh(a)
            })
        };
    var Bh = null,
        Ch = "",
        Dh = !1,
        Eh = function() {
            var a = Bh || C;
            if (!a) return "";
            var b = a.document,
                c = [];
            c.push("url=" + Na(a.location.href.substring(0, 512)));
            b && b.referrer && c.push("referrer=" + Na(b.referrer.substring(0, 512)));
            return c.join("&")
        };
    var Fh = !1,
        Gh = !1,
        Hh = !1,
        Ih = !1,
        Kh = function() {
            Fh = !0;
            try {
                Bf = Cf(), 1 > Math.random() && (Ih = !0), Bh = eb(C).Za, ah(!1), qh() ? (window.setTimeout(function() {}, 1), Af().b ? Jh() : $g()) : Dh = !0
            } catch (a) {
                throw U = [], a;
            }
        },
        Jh = function() {
            var a;
            if (fc && x(C.screenX) && x(C.mozInnerScreenX) && x(C.outerWidth) && 1 > Math.random()) {
                var b = C.navigator.userAgent,
                    c = b.indexOf("Firefox/");
                a = -1;
                if (0 <= c) {
                    a = Math.floor(b.substr(c + 8)) || -1;
                    var d = b.indexOf("Mac OS X 10."),
                        c = -1;
                    0 <= d && (c = Number(b.substr(d + 12, 1)) || -1);
                    var e = 0 < c ? -1 : b.indexOf("Windows NT "),
                        d = -1;
                    0 <= e && (d = {
                        "6.0": 0,
                        "6.1": 1,
                        "6.2": 2
                    }[b.substr(e + 11, 3)] || -1);
                    b = 148;
                    5 <= c ? b = 4 <= a ? 108 : 3 <= a ? 127 : 108 : 0 <= d && (16 == a || 17 == a || 18 == a) && (b = [
                        [146, 146, 146],
                        [148, 147, 148],
                        [131, 130, 136]
                    ][d][a - 16]);
                    a = b
                } else a = null;
                null !== a && (eh = a, Eg = !0);
                a = !0
            } else a = !1;
            a ? $g() : (a = C && C.document, a = I && J(8) && y(Lf(a)) ? Dg = !0 : !1, a ? (Gh = .1 > Math.random(), $g()) : sh() ? ($g(), Hh = !0) : (window.clearTimeout(lh), lh = null, Ch = "i", kh = !0))
        },
        rh = function(a) {
            if (a) {
                if (!a.Xb) {
                    var b = [];
                    b.push("v=322v");
                    b.push("r=fp");
                    b.push("efm=" + (Hh ? 1 : 0));
                    b.push(yc(T(a, "start")));
                    b.push(Eh());
                    Ia(("//pagead2.googlesyndication.com/pagead/gen_204?id=lidarvf&" + b.join("&")).substring(0, 2E3));
                    a.Xb = !0
                }
                a.Ja = !0
            }
        },
        bi = function(a, b, c) {
            var d = {};
            Qb(d, {
                opt_adElement: void 0,
                opt_fullscreen: void 0,
                opt_nativeMobile: !1
            }, c || {});
            var e = a.toLowerCase();
            if (a = Mb(function(a) {
                return a == e
            })) {
                a = {
                    v: "322v",
                    e: Ye[a]
                };
                if (d.opt_bounds) return a.msg = "ol", If(a);
                if (Dh) return a.msg = "ue", If(a);
                b = Lh(b, d);
                a.nas = U.length;
                if (!b) return a.msg = "nf", If(a);
                Fh || Kh();
                "i" == Ch && (b.Ja = !0);
                Gh && 7 == b.l && (b.$a = !0);
                c = d.opt_fullscreen;
                n(c) && (b.N = Boolean(c));
                rb(Xe, e) && (Mh(b, d), Ih && Nh(b));
                c = {};
                c.start = Oh;
                c.firstquartile = Ph;
                c.midpoint = Qh;
                c.thirdquartile = Rh;
                c.complete = Sh;
                c.pause = Th;
                c.resume = Uh;
                c.skip = Vh;
                c.viewable_impression = Wh;
                c.mute = Xh;
                c.unmute = Yh;
                c.fullscreen = Zh;
                c.exitfullscreen = $h;
                c.custom_viewable_impression = ai;
                if (c = c[e]) {
                    d = c(b, d);
                    if (!n(d) || w(d)) return d;
                    Qb(a, d);
                    return If(a)
                }
            }
        },
        Oh = function(a) {
            a.Ub++;
            Jg(a, 0);
            1 == (100 * a.o | 0) / 100 && .1 <= a.La && (a.Fb = !0);
            return T(a, "start")
        },
        Ph = function(a) {
            Jg(a, 1);
            bh([a], !Mg());
            return T(a, "firstquartile")
        },
        Qh = function(a) {
            Jg(a, 2);
            a.cb = !0;
            bh([a], !Mg()); - 1 == a.fb && a.cb && (a.fb = a.Ua);
            return T(a, "midpoint")
        },
        Rh = function(a) {
            Jg(a, 3);
            bh([a], !Mg());
            return T(a, "thirdquartile")
        },
        Sh = function(a) {
            Jg(a, 4);
            bh([a], !Mg());
            var b = T(a, "complete");
            a.N = !1;
            ci(a.w);
            return b
        },
        Th = function(a) {
            a.ab = Ig(a, Cf());
            var b = !Mg();
            bh([a], b);
            a.ta = !0;
            return T(a, "pause")
        },
        Uh = function(a) {
            var b = Mg();
            a.ta && !b && (a.oa = Cf());
            bh([a], !b);
            a.ta = !1;
            return T(a, "resume")
        },
        Wh = function(a) {
            var b = T(a, "viewable_impression");
            b.hvvi = "1";
            a.$b = !0;
            return b
        },
        Vh = function(a) {
            var b = !Mg();
            bh([a], b);
            b = T(a, "skip");
            a.N = !1;
            ci(a.w);
            return b
        },
        Xh = function(a) {
            bh([a], !Mg());
            return T(a, "mute")
        },
        Yh = function(a) {
            bh([a], !Mg());
            return T(a, "unmute")
        },
        Zh = function(a) {
            a.N = !0;
            bh([a], !Mg());
            return T(a, "fullscreen")
        },
        $h = function(a) {
            a.N = !1;
            bh([a], !Mg());
            return T(a, "exitfullscreen")
        },
        ai = function(a) {
            a = T(a, "custom_viewable_impression");
            a.std = "csm";
            return a
        },
        Mh = function(a, b) {
            if (!a.Zb) {
                a.Zb = !0;
                "i" != Ch && (kh = !1);
                !Hh || Boolean(a.j) || a.ia || Fg(a, rh, .1 > Math.random() ? 3 : 1, String(lb(U, a)));
                a.D = {};
                a.D.firstquartile = !1;
                a.D.midpoint = !1;
                a.D.thirdquartile = !1;
                a.D.complete = !1;
                a.D.pause = !1;
                a.D.skip = !1;
                a.D.viewable_impression = !1;
                a.ub = 0;
                var c = n(b) ? b.opt_nativeTime : void 0;
                Ff = c = x(c) ? c : Cf();
                a.na = [0, 0, 0, 0, 0];
                a.O = [0, 0, 0, 0, 0];
                a.B = [0, 0, 0, 0, 0];
                a.Ca = [0, 0, 0, 0, 0];
                a.J = -1;
                a.ka = -1;
                a.Cb = -1;
                a.Jb = 0;
                a.ad = -1;
                a.V = -1;
                a.$ = -1;
                a.o = 0;
                a.J = c;
                var d = !1;
                Mg() || (d = !0, a.oa = c);
                bh([a], d)
            }
        },
        ci = function(a) {
            if (w(a)) {
                var b = pb(U, function(b) {
                    return b.w == a
                });
                0 <= b && kb.splice.call(U, b, 1)
            }
        },
        Lh = function(a, b) {
            if (b.opt_nativeMobile) return di(a, b);
            if (b.opt_adElement) return ei(a,
                b.opt_adElement);
            var c = fi(a);
            return c ? c : c = qb(U, function(b) {
                return b.w == a
            })
        },
        di = function(a, b) {
            var c = qb(U, function(b) {
                return b.w == a
            });
            c || (c = new qg(window, "", null, b.opt_nativeTime, 7), c.m = "n", c.Ra = gi, th([c]), c.w = a, c.Kb = Af().h);
            return c
        },
        ei = function(a, b) {
            var c = qb(U, function(a) {
                return a.h == b
            });
            null !== c && c.w != a && (ci(c.w), c = null);
            c || (c = hi(b), c.w = a, c.m = "h");
            return c
        },
        fi = function(a) {
            var b = qb(U, function(b) {
                return b.h ? ii(b.h) == a : !1
            });
            null !== b && b.w != a && (ci(b.w), b = null);
            if (b) return b;
            b = ji();
            b = qb(b, function(b) {
                return ii(b) ==
                    a
            });
            if (!b) return null;
            b = hi(b);
            b.m = "as";
            ki(b);
            return b
        },
        ki = function(a) {
            var b = ii(a.h);
            w(b) && (a.w = b)
        },
        ji = function() {
            var a = C.document,
                b = zb(nb(["embed", "object"], function(b) {
                    return vb(a.getElementsByTagName(b))
                }));
            return b = mb(b, function(a) {
                if (!a || !ea(a) || 1 != a.nodeType || !y(a.getBoundingClientRect)) return !1;
                var b = a.getBoundingClientRect();
                return 0 != b.width && 0 != b.height && a.metricID && y(a.metricID) ? !0 : !1
            })
        },
        ii = function(a) {
            if (!a || !a.metricID || !y(a.metricID)) return null;
            var b;
            try {
                b = a.metricID()
            } catch (c) {
                return null
            }
            return b.queryID
        },
        hi = function(a) {
            a = new qg(C, "", a, -1, 7);
            a.Ra = gi;
            Af().g = 79463069;
            th([a]);
            $g();
            return a
        },
        gi = function(a) {
            if (!Hg(a) || a.ua) a.g = 3;
            else {
                var b = "as" == a.m,
                    c = "h" == a.m,
                    d = "n" == a.m,
                    e = aa("ima.common.triggerViewEvent"),
                    f = aa("ima.bridge.triggerViewEvent"),
                    g = {
                        e: 9,
                        Uf: "322v",
                        Tf: 1
                    },
                    k = T(a, "viewable_impression");
                Qb(g, k);
                a.Eb.viewable_impression = k;
                try {
                    var m = If(g);
                    c ? y(e) ? (e(a.w, m), a.ua = !0) : a.g = 4 : d ? y(f) ? (f(a.w, m), a.ua = !0) : a.g = 6 : b ? a.h && a.h.triggerViewEvent ? (a.h.triggerViewEvent(m), a.ua = !0) : a.g = 1 : a.g = 5
                } catch (p) {
                    a.g = a.g || 2
                }
            } if (a.cb &&
                (-1 != a.ga ? a.ba >= a.ga / 2 : a.ba >= a.fb) && !a.Hb && "as" == a.m) try {
                a.h && a.h.triggerExternalActivityEvent ? (a.h.triggerExternalActivityEvent("custom_viewable_impression"), a.Hb = !0) : a.g = 7
            } catch (t) {
                a.g = a.g || 8
            }
        },
        Nh = function(a) {
            if (a.gb || a.Ja) a.g = a.g || 13;
            else {
                var b = "as" == a.m,
                    c = "h" == a.m;
                try {
                    if (c) {
                        var d = aa("ima.common.triggerMeasurableEvent");
                        y(d) ? (d(a.w), a.gb = !0) : a.g = a.g || 14
                    } else b ? a.h && a.h.triggerMeasurableEvent ? (a.h.triggerMeasurableEvent(), a.gb = !0) : a.g = a.g || 11 : a.g = a.g || 15
                } catch (e) {
                    a.g = a.g || 12
                }
            }
        };
    r("Goog_AdSense_Lidar_sendVastMessage", cb("lidar::handlevast_ex", bi), void 0);
    r("Goog_AdSense_Lidar_getUrlSignalsArray", cb("lidar::geturlsignalsarray_ex", function() {
        return Ah()
    }), void 0);
    r("Goog_AdSense_Lidar_getUrlSignalsList", cb("lidar::geturlsignalslist_ex", function() {
        return Hd(Ah())
    }), void 0);
    var V = function(a, b, c) {
        N.call(this, a);
        this.j = b;
        this.h = null != c ? c : null
    };
    A(V, N);
    V.prototype.w = function() {
        return this.j
    };
    V.prototype.m = function() {
        return this.h
    };
    var W = function(a) {
        wd.call(this);
        this.j = a;
        this.g = {}
    };
    A(W, wd);
    var li = [];
    W.prototype.C = function(a, b, c, d) {
        return mi(this, a, b, c, d)
    };
    var mi = function(a, b, c, d, e, f) {
            v(c) || (c && (li[0] = c.toString()), c = li);
            for (var g = 0; g < c.length; g++) {
                var k = Ce(b, c[g], d || a.handleEvent, e || !1, f || a.j || a);
                if (!k) break;
                a.g[k.ib] = k
            }
            return a
        },
        ni = function(a, b, c, d, e, f) {
            if (v(c))
                for (var g = 0; g < c.length; g++) ni(a, b, c[g], d, e, f);
            else(b = Je(b, c, d || a.handleEvent, e, f || a.j || a)) && (a.g[b.ib] = b)
        };
    W.prototype.Ba = function(a, b, c, d, e) {
        if (v(b))
            for (var f = 0; f < b.length; f++) this.Ba(a, b[f], c, d, e);
        else c = c || this.handleEvent, e = e || this.j || this, c = De(c), d = !!d, b = qe(a) ? ye(a.ha, String(b), c, d, e) : a ? (a = Fe(a)) ? ye(a, b, c, d, e) : null : null, b && (Le(b), delete this.g[b.ib]);
        return this
    };
    var oi = function(a) {
        Eb(a.g, function(a, c) {
            this.g.hasOwnProperty(c) && Le(a)
        }, a);
        a.g = {}
    };
    W.prototype.H = function() {
        W.X.H.call(this);
        oi(this)
    };
    W.prototype.handleEvent = function() {
        throw Error("EventHandler.handleEvent not implemented");
    };
    var pi = function(a, b, c) {
        this.b = a;
        this.g = Math.min(Math.max(b || 0, 0), 1);
        this.h = null != c ? c : !0
    };
    var qi = function() {
            this.g = new F;
            this.b = null
        },
        ri = function(a) {
            var b = Math.random(),
                c = 0,
                d = a.g.Y();
            E(d, function(a) {
                c += a.g
            }, a);
            var e = 1 < c ? c : 1;
            a.b = null;
            for (var f = 0, g = 0; g < d.length; ++g)
                if (f += d[g].g, f / e >= b) {
                    a.b = d[g];
                    break
                }
        };
    var ui = function() {
            this.g = null != l.G_testRunner;
            this.b = new F;
            X(this, "ActiveViewExternalLayer", 41351040, .2);
            X(this, "ActiveViewExternalLayer", 41351041, .2);
            X(this, "ActiveViewExternalLayer", 41351042, .2);
            X(this, "ActiveViewExternalLayer", 41351043, .2);
            X(this, "GvnExternalLayer", 41351050, .02);
            X(this, "GvnExternalLayer", 41351051, .02);
            X(this, "GvnExternalLayer", 41351052, .02);
            X(this, "GvnExternalLayer", 41351053, .02);
            X(this, "GvnExternalLayer", 41351094, .05);
            X(this, "GvnExternalLayer", 41351095, .05);
            X(this, "GvnExternalLayer",
                41351098, .01);
            X(this, "GvnExternalLayer", 41351099, .01);
            X(this, "GvnExternalLayer", 41351046, .01);
            X(this, "GvnExternalLayer", 41351044, .01);
            X(this, "GvnExternalLayer", 41351080, .05);
            X(this, "GvnExternalLayer", 41351081, .05);
            si(this);
            var a;
            a = Bd(O);
            a = Ed(a);
            null != a && (this.g = !1, ti(this, a.map(String)))
        },
        vi = null,
        wi = function() {
            vi || (vi = new ui);
            return vi
        },
        X = function(a, b, c, d) {
            ka(va(b)) || isNaN(c) || 0 >= c || (c = new pi(c, d), a = xi(a, b), Tb(a.g, c.b, c))
        },
        si = function(a) {
            Dd() || O.ob() || E(a.b.Y(), function(a) {
                ri(a)
            }, a)
        },
        ti = function(a,
            b) {
            E(b, function(a) {
                var b = Number(a);
                a = "forcedLayer" + a;
                isNaN(b) || 0 >= b || ka(va(a)) || (a = xi(this, a), b = new pi(b, 0, !0), a.b = b)
            }, a)
        },
        yi = function(a) {
            var b = wi();
            return b.g ? !1 : ob(b.b.Y(), function(b) {
                return !!b.b && b.b.b == a
            })
        },
        zi = function() {
            var a = wi();
            if (a.g) return "";
            var b = [];
            E(a.b.Y(), function(a) {
                (a = a.b) && a.h && b.push(a.b)
            });
            return b.sort().join(",")
        },
        xi = function(a, b) {
            var c = a.b.get(b);
            null == c && (c = new qi, Tb(a.b, b, c));
            return c
        };
    var Ai = {},
        Bi = "",
        Ci = /OS (\S+) like/,
        Di = /Android ([\d\.]+)/,
        Fi = function() {
            return !O.ma() && Ei()
        },
        Ei = function() {
            return ic || B(G, "Mobile")
        },
        Gi = function() {
            return jc && !kc || B(G, "iPod")
        },
        Hi = function() {
            return Gi() || kc
        },
        Ii = function(a, b) {
            if (null == Ai[b]) {
                var c;
                ka(Bi) && (c = a.exec(G)) && (Bi = c[1]);
                (c = Bi) ? (c = c.replace(/_/g, "."), Ai[b] = 0 <= xa(c, b)) : Ai[b] = !1
            }
            return Ai[b]
        },
        Ji = function() {
            var a = G;
            return a ? B(a, "AppleTV") || B(a, "GoogleTV") || B(a, "HbbTV") || B(a, "NetCast.TV") || B(a, "Opera TV") || B(a, "POV_TV") || B(a, "SMART-TV") || B(a, "SmartTV") ||
                ic && B(a, "AFT") : !1
        },
        Ki = function() {
            var a = G;
            return a ? B(a, "Nintendo WiiU") : !1
        },
        Li = function() {
            return B(G, "PlayStation")
        },
        Mi = function() {
            return !O.ma() && Fi() || O.ma() && ic && (!ic || !Ii(Di, 4.2)) || B(G, "CrKey") || Li() || B(G, "Roku") || Ji() || B(G, "Xbox") ? !1 : !0
        };
    var Ni = function() {
        S.call(this);
        this.b = null;
        this.l = new W(this);
        xd(this, ha(yd, this.l));
        this.m = null;
        this.j = new F;
        this.g = new F;
        this.h = !1
    };
    A(Ni, S);
    var Oi = null,
        Pi = function() {
            null != Oi || (Oi = new Ni);
            return Oi
        },
        Qi = function(a) {
            var b = Pi();
            a = b.j.get(a) || b.m;
            return null != a ? a() : {}
        },
        Si = function(a) {
            if (null == a) return !1;
            if (Gi() && null != a.webkitDisplayingFullscreen) return a.webkitDisplayingFullscreen;
            var b = window.screen.availWidth || window.screen.width,
                c = window.screen.availHeight || window.screen.height;
            a = Ri(a);
            return 0 >= b - a.width && 42 >= c - a.height
        },
        Ri = function(a) {
            return y(a.getBoundingClientRect) && md(bd(a), a) ? a.getBoundingClientRect() : {
                left: a.offsetLeft,
                top: a.offsetTop,
                width: a.offsetWidth,
                height: a.offsetHeight
            }
        },
        Ti = function(a, b, c, d, e) {
            if (a.h) {
                e = e || {};
                if (a = d ? a.g.get(d) : O.b) null != e.opt_fullscreen || (e.opt_fullscreen = Si(a)), null != e.opt_adElement || (e.opt_adElement = a);
                return $a("lidar::handlevast_html5", ha(bi, b, c, e)) || ""
            }
            return ""
        },
        Ui = function(a, b, c) {
            c ? null === b ? Wb(a.j, c) : Tb(a.j, c, b) : a.m = b
        },
        Vi = function(a) {
            if (y(window.Goog_AdSense_Lidar_getUrlSignalsArray)) {
                var b = {};
                b.pageSignals = window.Goog_AdSense_Lidar_getUrlSignalsArray();
                a.b.send("activityMonitor", "pageSignals", b)
            }
        };
    Ni.prototype.o = function(a) {
        var b = a.P,
            c = b.queryId,
            d = {};
        d.eventId = b.eventId;
        switch (a.U) {
            case "getPageSignals":
                Vi(this);
                break;
            case "getViewability":
                d.viewabilityString = Ti(this, "metric", c) || "";
                this.b.send("activityMonitor", "viewability", d);
                break;
            case "reportVastEvent":
                var e = b.vastEvent;
                a = b.osdId;
                var f = {};
                f.opt_fullscreen = b.isFullscreen;
                b.isOverlay && (f.opt_bounds = b.overlayBounds);
                var g = null;
                "isFullscreen" in b && (g = b.isFullscreen);
                d.viewabilityString = Ti(this, e, c, a, f);
                d.engagementString = Wi(this, a, g);
                this.b.send("activityMonitor",
                    "viewability", d);
                break;
            case "fetchAdTagUrl":
                c = {}, c.eventId = b.eventId, a = b.osdId, g = null, "isFullscreen" in b && (g = b.isFullscreen), c.engagementString = Wi(this, a, g), this.b.send("activityMonitor", "engagement", c)
        }
    };
    var Wi = function(a, b, c) {
        var d = b ? a.g.get(b) : O.b;
        a = {};
        null != c && (a.fullscreen = c);
        return We(function() {
            return d
        }, a)
    };
    r("ima.common.getVideoMetadata", Qi, void 0);
    r("ima.common.sdkVolume", function(a) {
        a = Qi(a).volume;
        return null != a ? a : -1
    }, void 0);
    r("ima.common.triggerViewEvent", function(a, b) {
        var c = {};
        c.queryId = a;
        c.viewabilityString = b;
        var d = Pi().b;
        d ? d.send("activityMonitor", "viewableImpression", c) : Pi().dispatchEvent(new V("viewable_impression", null, c))
    }, void 0);
    r("ima.common.triggerMeasurableEvent", function(a) {
        var b = {};
        b.queryId = a;
        (a = Pi().b) ? a.send("activityMonitor", "measurableImpression", b) : Pi().dispatchEvent(new V("measurable_impression", null, b))
    }, void 0);
    var Xi = function(a, b, c) {
        this.g = c;
        0 == b.length && (b = [
            []
        ]);
        this.b = nb(b, function(b) {
            b = a.concat(b);
            for (var c = [], f = 0, g = 0; f < b.length;) {
                var k = b[f++];
                if (128 > k) c[g++] = String.fromCharCode(k);
                else if (191 < k && 224 > k) {
                    var m = b[f++];
                    c[g++] = String.fromCharCode((k & 31) << 6 | m & 63)
                } else {
                    var m = b[f++],
                        p = b[f++];
                    c[g++] = String.fromCharCode((k & 15) << 12 | (m & 63) << 6 | p & 63)
                }
            }
            return new RegExp(c.join(""))
        })
    };
    Xi.prototype.match = function(a) {
        return ob(this.b, function(b) {
            b = a.match(b);
            return null == b ? !1 : !this.g || 1 <= b.length && "3.101.4" == b[1] || 2 <= b.length && "3.101.4" == b[2] ? !0 : !1
        }, this)
    };
    var Yi = [104, 116, 116, 112, 115, 63, 58, 47, 47, 105, 109, 97, 115, 100, 107, 92, 46, 103, 111, 111, 103, 108, 101, 97, 112, 105, 115, 46, 99, 111, 109, 47, 106, 115, 47, 40, 115, 100, 107, 108, 111, 97, 100, 101, 114, 124, 99, 111, 114, 101, 41, 47],
        Zi = [104, 116, 116, 112, 115, 63, 58, 47, 47, 115, 48, 92, 46, 50, 109, 100, 110, 92, 46, 110, 101, 116, 47, 105, 110, 115, 116, 114, 101, 97, 109, 47, 104, 116, 109, 108, 53, 47],
        $i = [
            [105, 109, 97, 51, 92, 46, 106, 115],
            [105, 109, 97, 51, 95, 100, 101, 98, 117, 103, 92, 46, 106, 115],
            [105, 109, 97, 51, 95, 116, 101, 115, 116, 46, 106, 115],
            [105, 109, 97, 51, 95, 108, 111, 97,
                100, 101, 114, 92, 46, 106, 115
            ],
            [105, 109, 97, 51, 95, 108, 111, 97, 100, 101, 114, 95, 100, 101, 98, 117, 103, 92, 46, 106, 115]
        ],
        aj = [
            [98, 114, 105, 100, 103, 101, 40, 91, 48, 45, 57, 93, 43, 92, 46, 91, 48, 45, 57, 92, 46, 93, 43, 41, 40, 95, 91, 97, 45, 122, 93, 91, 97, 45, 122, 93, 41, 123, 48, 44, 50, 125, 92, 46, 104, 116, 109, 108],
            [98, 114, 105, 100, 103, 101, 40, 91, 48, 45, 57, 93, 43, 92, 46, 91, 48, 45, 57, 92, 46, 93, 43, 41, 95, 100, 101, 98, 117, 103, 40, 95, 91, 97, 45, 122, 93, 91, 97, 45, 122, 93, 41, 123, 48, 44, 50, 125, 92, 46, 104, 116, 109, 108],
            [98, 114, 105, 100, 103, 101, 40, 91, 48, 45, 57, 93, 43, 92, 46,
                91, 48, 45, 57, 92, 46, 93, 43, 41, 95, 116, 101, 115, 116, 40, 95, 91, 97, 45, 122, 93, 91, 97, 45, 122, 93, 41, 123, 48, 44, 50, 125, 92, 46, 104, 116, 109, 108
            ],
            [98, 114, 105, 100, 103, 101, 40, 95, 91, 97, 45, 122, 93, 91, 97, 45, 122, 93, 41, 123, 48, 44, 50, 125, 46, 104, 116, 109, 108]
        ],
        bj = new Xi(Yi, $i, !1),
        cj = new Xi(Yi, aj, !0),
        dj = new Xi(Zi, $i, !1),
        ej = new Xi(Zi, aj, !0),
        fj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 119, 119, 119, 92, 46, 103, 115, 116, 97, 116, 105, 99, 92, 46, 99, 111, 109, 47, 97, 100, 109, 111, 98, 47, 106, 115, 47, 97, 112, 118, 95, 116, 101, 109, 112, 108, 97, 116, 101, 115, 46,
            106, 115
        ], [], !1),
        gj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 109, 105, 110, 116, 45, 109, 97, 100, 92, 46, 115, 97, 110, 100, 98, 111, 120, 92, 46, 103, 111, 111, 103, 108, 101, 92, 46, 99, 111, 109, 47, 109, 97, 100, 115, 47, 115, 116, 97, 116, 105, 99, 47, 102, 111, 114, 109, 97, 116, 115, 47, 97, 112, 118, 95, 116, 101, 109, 112, 108, 97, 116, 101, 115, 46, 106, 115], [], !1),
        hj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 105, 109, 97, 115, 100, 107, 92, 46, 103, 111, 111, 103, 108, 101, 97, 112, 105, 115, 92, 46, 99, 111, 109, 47, 106, 115, 47, 99, 111, 114, 101, 47, 97, 100, 109, 111, 98, 47], aj, !1),
        ij = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 103, 111, 111, 103, 108, 101, 97, 100, 115, 92, 46, 103, 92, 46, 100, 111, 117, 98, 108, 101, 99, 108, 105, 99, 107, 92, 46, 110, 101, 116, 47, 109, 97, 100, 115, 47, 115, 116, 97, 116, 105, 99], [], !1),
        jj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 118, 105, 100, 101, 111, 45, 97, 100, 45, 116, 101, 115, 116, 92, 46, 97, 112, 112, 115, 112, 111, 116, 92, 46, 99, 111, 109, 47], [], !1),
        kj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 105, 109, 97, 115, 100, 107, 92, 46, 103, 111, 111, 103, 108, 101, 97, 112, 105, 115, 92, 46, 99, 111, 109, 47, 112, 114, 101, 114,
            101, 108, 101, 97, 115, 101, 47, 106, 115, 47, 91, 48, 45, 57, 93, 43, 92, 46, 91, 48, 45, 57, 92, 46, 93, 43, 47
        ], $i, !1),
        lj = new Xi([104, 116, 116, 112, 115, 63, 58, 47, 47, 112, 97, 103, 101, 97, 100, 50, 92, 46, 103, 111, 111, 103, 108, 101, 115, 121, 110, 100, 105, 99, 97, 116, 105, 111, 110, 92, 46, 99, 111, 109, 47, 112, 97, 103, 101, 97, 100, 47, 103, 97, 100, 103, 101, 116, 115, 47], [], !1),
        Fb = {
            m: bj,
            w: cj,
            A: dj,
            D: ej,
            b: fj,
            g: gj,
            h: hj,
            j: ij,
            l: jj,
            o: kj,
            B: lj
        };
    var mj = ["://secure-...imrworldwide.com/", "://cdn.imrworldwide.com/", "://aksecure.imrworldwide.com/", "www.google.com/pagead/sul", "www.youtube.com/pagead/sul"],
        nj = /\bocr\b/,
        oj = 0,
        pj = {},
        qj = function(a) {
            return ka(va(a)) ? !1 : Qc(new Cc(a)).match(nj) ? !0 : null != qb(mj, function(b) {
                return null != a.match(b)
            })
        },
        sj = function(a, b) {
            if (a) {
                var c, d = 'javascript:"data:text/html,<body><img src=\\"' + a + '\\"></body>"';
                b ? rj(function(b) {
                    c = b ? d : 'javascript:"data:text/html,<body><object data=\\"' + a + '\\" width=1 height=1 style=\\"visibility:hidden;\\"></body>"'
                }) :
                    c = d;
                var e = jd("iframe", {
                        src: c,
                        style: "display:none"
                    }),
                    f = bd(e).body,
                    g, k = Se(function() {
                        Le(g);
                        ld(e)
                    }, 15E3);
                g = Je(e, ["load", "error"], function() {
                    Se(function() {
                        l.clearTimeout(k);
                        ld(e)
                    }, 5E3)
                });
                f.appendChild(e)
            }
        },
        rj = function(a) {
            var b = pj.imageLoadingEnabled;
            if (null != b) a(b);
            else {
                var c = function(b) {
                        null == pj.imageLoadingEnabled && (pj.imageLoadingEnabled = b, a(b))
                    },
                    b = new Image,
                    d;
                b.onload = function() {
                    clearTimeout(d);
                    c(!0)
                };
                b.src = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==";
                d = setTimeout(c,
                    0, !1)
            }
        },
        tj = function(a) {
            if (a) {
                var b = document.createElement("OBJECT");
                b.data = a;
                b.width = 1;
                b.height = 1;
                b.style.visibility = "hidden";
                var c = "" + oj++;
                pj[c] = b;
                b.onload = b.onerror = function() {
                    delete pj[c]
                };
                document.body.appendChild(b)
            }
        },
        uj = function(a) {
            if (a) {
                var b = new Image,
                    c = "" + oj++;
                pj[c] = b;
                b.onload = b.onerror = function() {
                    delete pj[c]
                };
                b.src = a
            }
        },
        vj = function(a, b) {
            b ? rj(function(b) {
                b ? uj(a) : tj(a)
            }) : uj(a)
        };
    var wj = function(a, b) {
        return a.replace(/(\[|%5B)([a-zA-Z0-9_]+)(\]|%5D)/g, function(a, d, e) {
            try {
                var f = Nb(b, e),
                    f = f.toString();
                if (!ka(va(f))) return encodeURIComponent(f).replace(/%2C/g, ",")
            } catch (g) {}
            return a
        })
    };
    var xj = {
        jf: "video/mp4",
        lf: "video/mpeg",
        ff: "application/x-mpegURL",
        qf: "video/ogg",
        Ef: "video/3gpp",
        Rf: "video/webm",
        hf: "audio/mpeg",
        kf: "audio/mp4"
    };
    var yj = ["*.googlesyndication.com"],
        zj = ["*.youtu.be", "*.youtube.com"],
        Aj = "ad.doubleclick.net bid.g.doubleclick.net corp.google.com ggpht.com google.co.uk google.com googleads.g.doubleclick.net googleads4.g.doubleclick.net googleadservices.com googlesyndication.com googleusercontent.com gstatic.com gvt1.com prod.google.com pubads.g.doubleclick.net s0.2mdn.net static.doubleclick.net static.doubleclick.net surveys.g.doubleclick.net youtube.com ytimg.com".split(" "),
        Bj = ["c.googlesyndication.com"],
        Dj = function(a,
            b) {
            try {
                var c = Nc(new Cc(b)),
                    c = c.replace(/^www./i, "");
                return ob(a, function(a) {
                    return Cj(a, c)
                })
            } catch (d) {
                return !1
            }
        },
        Cj = function(a, b) {
            if (ka(va(b))) return !1;
            a = a.toLowerCase();
            b = b.toLowerCase();
            return "*." == a.substr(0, 2) ? (a = a.substr(2), a.length > b.length ? !1 : b.substr(-a.length) == a && (b.length == a.length || "." == b.charAt(b.length - a.length - 1))) : a == b
        },
        Fj = function(a) {
            if (Ej(a, Bj)) return a;
            if ("https:" == window.location.protocol && (Ej(a, Aj) || O.Qa() && yi(952626))) {
                var b = new Cc(a);
                if ("https" == b.h) return a;
                Dc(b, "https");
                return b.toString()
            }
            return a
        },
        Ej = function(a, b) {
            return (new RegExp("^https?://([a-z0-9-]{1,63}\\.)*(" + b.join("|").replace(/\./g, "\\.") + ")(:[0-9]+)?([/?#]|$)", "i")).test(a)
        };
    var Gj = function(a) {
        try {
            a: {
                var b = a,
                    c = void 0,
                    d = b.length - 12 - 2;
                if (!(-1 == b.indexOf("PAGE_SIGNALS") || 2048 <= d || !c && !window.Goog_AdSense_Lidar_getUrlSignalsArray))
                    for (var c = c || window.Goog_AdSense_Lidar_getUrlSignalsArray(), d = {}, e = 0; e < c.length; ++e) {
                        d.PAGE_SIGNALS = c[e];
                        var f = wj(b, d);
                        if (2048 > f.length) {
                            a = f;
                            break a
                        }
                    }
                a = b
            }
        } catch (g) {}
        try {
            a = Fj(a);
            var k = yi(41351099);
            a && (qj(a) ? sj(a, k) : vj(a, k))
        } catch (m) {}
    };
    var Hj = function() {
        this.g = .01 > Math.random();
        this.b = Math.floor(4503599627370496 * Math.random())
    };
    Hj.getInstance = function() {
        return Hj.b ? Hj.b : Hj.b = new Hj
    };
    var Kj = function(a, b, c, d) {
            if ((a.g || d) && !O.ob()) {
                c = c || {};
                c.lid = b;
                b = zi();
                ka(va(b)) || (c.e = b);
                c = Ij(a, c);
                var e = new Cc("http://pagead2.googlesyndication.com/pagead/gen_204");
                Eb(c, function(a, b) {
                    var c = null != a ? "boolean" == typeof a ? a ? "t" : "f" : "" + a : "",
                        d = e.g,
                        p = b;
                    Tc(d);
                    d.h = null;
                    p = Uc(d, p);
                    Wc(d, p) && (d.g -= d.b.get(p).length);
                    Tb(d.b, p, [c]);
                    d.g++
                }, a);
                a = Jj();
                Dc(e, a.h);
                Gj(e.toString())
            }
        },
        Ij = function(a, b) {
            b.id = "ima_html5";
            var c = Jj();
            b.c = a.b;
            b.domain = c.b;
            return b
        },
        Jj = function() {
            var a = M(),
                b = document;
            return new Cc(a.parent ==
                a ? a.location.href : b.referrer)
        };
    var Lj = function() {
            this.b = -1
        },
        Mj = new Lj;
    Lj.prototype.clear = function() {};
    var Nj = function(a) {
        this.g = a
    };
    Nj.prototype.b = function() {
        return this.g
    };
    var Oj = function() {
        S.call(this);
        this.currentTime = 0
    };
    A(Oj, S);
    var Pj = function(a, b) {
            this.message = a;
            this.errorCode = b
        },
        Qj = new Pj("Invalid usage of the API. Cause: {0}", 900),
        Rj = new Pj("Failed to initialize ad playback element before starting ad playback.", 400),
        Sj = new Pj("The provided {0} information: {1} is invalid.", 1101),
        Tj = function(a, b, c) {
            var d;
            d = b || null;
            if (!(d instanceof vd)) {
                var e = a.errorCode,
                    f = a.message,
                    g = xb(arguments, 2);
                if (0 < g.length)
                    for (var k = 0; k < g.length; k++) f = f.replace(new RegExp("\\{" + k + "\\}", "ig"), g[k]);
                e = new vd("adPlayError", f, e);
                e.g = d;
                d = e
            }
            return d
        };
    var Uj = function(a) {
        Oj.call(this);
        this.currentTime = a.currentTime;
        if (!("currentTime" in a) || isNaN(a.currentTime)) throw Tj(Sj, null, "content", "currentTime");
        this.g = a;
        this.b = new Qe(250);
        this.h = new W(this);
        mi(this.h, this.b, "tick", this.j, !1, this)
    };
    A(Uj, Oj);
    Uj.prototype.start = function() {
        this.b.start()
    };
    Uj.prototype.H = function() {
        Uj.X.H.call(this);
        this.h.M();
        this.b.M()
    };
    Uj.prototype.j = function() {
        if ("currentTime" in this.g && !isNaN(this.g.currentTime)) {
            var a = this.currentTime;
            this.currentTime = this.g.currentTime;
            a != this.currentTime && this.dispatchEvent(new N("currentTimeUpdate"))
        } else this.dispatchEvent(new N("contentWrapperError")), Re(this.b)
    };
    var Vj = function(a, b) {
        V.call(this, "adMetadata", a);
        this.g = b || null
    };
    A(Vj, V);
    Vj.prototype.l = function() {
        return this.g
    };
    var Wj = function() {
        S.call(this);
        this.m = this.A = this.G = this.B = !1;
        this.g = 0;
        this.j = [];
        this.o = !1;
        this.J = this.I = Infinity;
        this.h = 0;
        this.l = new W(this);
        this.F = {}
    };
    A(Wj, S);
    var Yj = function(a, b) {
            null == b || a.B || (a.b = b, Xj(a), a.B = !0)
        },
        ak = function(a) {
            null != a.b && a.B && (Zj(a), a.B = !1, a.A = !1, a.m = !1, a.g = 0, a.j = [], a.o = !1)
        },
        Xj = function(a) {
            Zj(a);
            !(a.b instanceof S) && "ontouchstart" in document.documentElement && Hi() ? (a.F = {
                touchstart: z(a.T, a),
                touchmove: z(a.O, a),
                touchend: z(a.N, a)
            }, Eb(a.F, function(a, c) {
                this.b.addEventListener(c, a, !1)
            }, a)) : a.l.C(a.b, "click", a.L)
        },
        Zj = function(a) {
            a.l.Ba(a.b, "click", a.L);
            Eb(a.F, function(a, c) {
                this.b.removeEventListener(c, a, !1)
            }, a);
            a.F = {}
        };
    Wj.prototype.T = function(a) {
        this.A = !0;
        this.g = a.touches.length;
        this.h && (window.clearTimeout(this.h), this.h = 0, this.G = !0);
        (this.o = bk(this, a.touches) || 1 != a.touches.length) ? this.J = this.I = Infinity : (this.I = a.touches[0].clientX, this.J = a.touches[0].clientY);
        ck(this, a.touches)
    };
    Wj.prototype.O = function(a) {
        this.g = a.touches.length;
        if (!Hi() || !Ii(Ci, 8) || Math.pow(a.changedTouches[0].clientX - this.I, 2) + Math.pow(a.changedTouches[0].clientY - this.J, 2) > Math.pow(5, 2)) this.m = !0
    };
    Wj.prototype.N = function(a) {
        !this.A || 1 != this.g || this.m || this.G || this.o || !bk(this, a.changedTouches) || (this.h = window.setTimeout(z(this.K, this), 300));
        this.g = a.touches.length;
        0 == this.g && (this.m = this.A = !1, this.j = []);
        this.G = !1
    };
    Wj.prototype.L = function() {
        this.K()
    };
    var ck = function(a, b) {
            a.j = [];
            E(b, function(a) {
                var b = this.j;
                a = a.identifier;
                rb(b, a) || b.push(a)
            }, a)
        },
        bk = function(a, b) {
            return ob(b, function(a) {
                return rb(this.j, a.identifier)
            }, a)
        };
    Wj.prototype.K = function() {
        this.h = 0;
        this.dispatchEvent(new N("click"))
    };
    Wj.prototype.H = function() {
        ak(this);
        this.l.M();
        this.l = null;
        Wj.X.H.call(this)
    };
    var dk = function() {
        this.b = [];
        this.g = []
    };
    h = dk.prototype;
    h.pa = function() {
        return this.b.length + this.g.length
    };
    h.isEmpty = function() {
        return 0 == this.b.length && 0 == this.g.length
    };
    h.clear = function() {
        this.b = [];
        this.g = []
    };
    h.contains = function(a) {
        return rb(this.b, a) || rb(this.g, a)
    };
    h.Y = function() {
        for (var a = [], b = this.b.length - 1; 0 <= b; --b) a.push(this.b[b]);
        for (var c = this.g.length, b = 0; b < c; ++b) a.push(this.g[b]);
        return a
    };
    var ek = function() {},
        fk = {
            IMAGE: "Image",
            Ye: "Flash",
            Ic: "All"
        },
        gk = {
            bf: "Html",
            IFRAME: "IFrame",
            Df: "Static",
            Ic: "All"
        },
        hk = {
            cf: "IgnoreSize",
            xf: "SelectExactMatch",
            yf: "SelectNearMatch"
        };
    var jk = function(a, b) {
            if (null == a || 0 >= a.width || 0 >= a.height) throw Tj(Sj, null, "ad slot size", a.toString());
            this.g = a;
            this.b = null != b ? b : new ek;
            this.l = ik(gk, this.b.j) ? this.b.j : "All";
            this.j = ik(fk, this.b.h) ? this.b.h : "All";
            this.m = ik(hk, this.b.l) ? this.b.l : "SelectExactMatch";
            this.h = null != this.b.g ? this.b.g : [];
            this.w = x(this.b.b) && 0 < this.b.b && 100 >= this.b.b ? this.b.b : 90
        },
        mk = function(a, b) {
            var c = [];
            E(b, function(a) {
                    !ka(a.b) && (isNaN(a.w) || isNaN(a.l) || a.l == a.w) && kk(this, a) ? c.push(a) : (a = lk(this, a), null != a && !ka(a.b) && c.push(a))
                },
                a);
            return c
        },
        kk = function(a, b) {
            var c;
            if (c = "Flash" != b.g() || kf) {
                if (c = "All" == a.l || a.l == b.A) c = b.g(), c = null != c ? "All" == a.j || a.j == c : !0;
                c && (c = b.B, c = 0 == a.h.length ? !0 : null != c ? 0 <= lb(a.h, c) : !1)
            }
            if (c) {
                c = b.h;
                var d;
                (d = "IgnoreSize" == a.m) || (d = a.g, d = d == c ? !0 : d && c ? d.width == c.width && d.height == c.height : !1);
                c = d ? !0 : "SelectNearMatch" == a.m && (c.width > a.g.width || c.height > a.g.height || c.width < a.w / 100 * a.g.width || c.height < a.w / 100 * a.g.height ? !1 : !0)
            } else c = !1;
            return c
        },
        lk = function(a, b) {
            var c = b.j;
            return null != c ? qb(c, function(a) {
                return kk(this,
                    a)
            }, a) : null
        },
        ik = function(a, b) {
            var c;
            if (c = null != b) a: {
                for (var d in a)
                    if (a[d] == b) {
                        c = !0;
                        break a
                    }
                c = !1
            }
            return c
        };
    var nk = function(a) {
        var b = {};
        E(a.split(","), function(a) {
            var d = a.split("=");
            2 == d.length && (a = la(d[0]), d = la(d[1]), 0 < a.length && (b[a] = d))
        });
        return b
    };
    var ok = function() {
        this.w = 1;
        this.h = -1;
        this.b = 1;
        this.l = this.j = 0;
        this.g = !1
    };
    h = ok.prototype;
    h.yd = function() {
        return this.w
    };
    h.vd = function() {
        return this.h
    };
    h.sd = function() {
        return this.b
    };
    h.wd = function() {
        return this.j
    };
    h.xd = function() {
        return this.l
    };
    h.ud = function() {
        return this.g
    };
    var pk = function(a) {
        this.b = a.content;
        this.m = a.contentType;
        this.h = a.size;
        this.l = a.masterSequenceNumber;
        this.A = a.resourceType;
        this.w = a.sequenceNumber;
        this.B = a.adSlotId;
        this.j = [];
        a = a.backupCompanions;
        null != a && (this.j = nb(a, function(a) {
            return new pk(a)
        }))
    };
    pk.prototype.getContent = function() {
        return this.b
    };
    pk.prototype.g = function() {
        return this.m
    };
    pk.prototype.D = function() {
        return this.h.width
    };
    pk.prototype.o = function() {
        return this.h.height
    };
    var Y = function(a) {
        this.b = a
    };
    h = Y.prototype;
    h.zd = function() {
        return this.b.adId
    };
    h.Cd = function() {
        return this.b.adSystem
    };
    h.ic = function() {
        return this.b.clickThroughUrl
    };
    h.Ld = function() {
        return this.b.adWrapperIds
    };
    h.Md = function() {
        return this.b.adWrapperSystems
    };
    h.Nd = function() {
        return this.b.linear
    };
    h.Od = function() {
        return this.b.skippable
    };
    h.Ed = function() {
        return this.b.contentType
    };
    h.fd = function() {
        return this.b.description
    };
    h.gd = function() {
        return this.b.title
    };
    h.lb = function() {
        return this.b.duration
    };
    h.Kd = function() {
        return this.b.width
    };
    h.Fd = function() {
        return this.b.height
    };
    h.Jd = function() {
        return this.b.uiElements
    };
    h.Gd = function() {
        return this.b.minSuggestedDuration
    };
    h.Bd = function() {
        var a = this.b.adPodInfo,
            b = new ok;
        b.j = a.podIndex;
        b.l = a.timeOffset;
        b.w = a.totalAds;
        b.b = a.adPosition;
        b.g = a.isBumper;
        b.h = a.maxDuration;
        return b
    };
    h.Dd = function(a, b, c) {
        var d = nb(this.b.companions, function(a) {
            return new pk(a)
        });
        return mk(new jk(new L(a, b), c), d)
    };
    h.Hd = function() {
        return nk(va(this.b.traffickingParameters))
    };
    h.Id = function() {
        return this.b.traffickingParameters
    };
    var qk = function() {};
    qk.prototype.disableClickThrough = !1;
    qk.prototype.mimeTypes = null;
    qk.prototype.restoreCustomPlaybackStateOnAdBreakComplete = !1;
    var rk = function(a) {
        if (ka(va(a))) return null;
        var b = a.match(/^https?:\/\/[^\/]*youtu\.be\/([a-zA-Z0-9_-]+)$/);
        if (null != b && 2 == b.length) return b[1];
        b = a.match(/^https?:\/\/[^\/]*youtube.com\/video\/([a-zA-Z0-9_-]+)$/);
        if (null != b && 2 == b.length) return b[1];
        b = a.match(/^https?:\/\/[^\/]*youtube.com\/watch\/([a-zA-Z0-9_-]+)$/);
        if (null != b && 2 == b.length) return b[1];
        a = (new Cc(a)).g;
        return Wc(a, "v") ? a.get("v").toString() : Wc(a, "video_id") ? a.get("video_id").toString() : null
    };
    var sk = function(a) {
        this.g = 0;
        this.h = a || 100;
        this.b = []
    };
    h = sk.prototype;
    h.get = function(a) {
        if (a >= this.b.length) throw Error("Out of bounds exception");
        a = this.b.length < this.h ? a : (this.g + Number(a)) % this.h;
        return this.b[a]
    };
    h.pa = function() {
        return this.b.length
    };
    h.isEmpty = function() {
        return 0 == this.b.length
    };
    h.clear = function() {
        this.g = this.b.length = 0
    };
    h.Y = function() {
        for (var a = this.pa(), b = this.pa(), c = [], a = this.pa() - a; a < b; a++) c.push(this.get(a));
        return c
    };
    h.la = function() {
        for (var a = [], b = this.pa(), c = 0; c < b; c++) a[c] = c;
        return a
    };
    var tk = function() {
        S.call(this)
    };
    A(tk, S);
    var uk = {
        Pe: "beginFullscreen",
        CLICK: "click",
        Ue: "end",
        Ve: "endFullscreen",
        ERROR: "error",
        LOADED: "loaded",
        gf: "mediaLoadTimeout",
        Ob: "pause",
        tf: "play",
        Bf: "skip",
        Cf: "skipShown",
        We: "extend",
        Xe: "extendShown",
        Oe: "notExtended",
        Sb: "start",
        Gf: "timeUpdate",
        Qe: "cardsStateChange",
        Ff: "timedMetadata",
        Qf: "volumeChange"
    };
    tk.prototype.ia = ba;
    var vk = function(a) {
        S.call(this);
        this.b = a;
        this.O = "";
        this.o = -1;
        this.T = new sk(4);
        this.h = 0;
        this.N = this.G = this.j = this.F = this.B = !1;
        this.K = this.wa();
        this.J = this.ya();
        this.V = 15E3;
        this.L = !1
    };
    A(vk, tk);
    h = vk.prototype;
    h.ec = function() {
        return mb(Ib(xj), function(a) {
            return !ka(this.b.canPlayType(a))
        }, this)
    };
    h.Hc = function(a) {
        this.V = 0 < a.b ? a.b : 15E3
    };
    h.yc = function(a) {
        this.b.seekable.length ? this.b.seekable.end(0) > this.o && (this.b.currentTime = this.o, a()) : setTimeout(z(this.yc, this, a), 100)
    };
    h.Gc = function() {
        this.O = this.b.currentSrc;
        this.b.ended ? this.o = -1 : this.o = this.b.currentTime
    };
    h.Ec = function(a) {
        if (0 <= this.o) {
            var b = this;
            this.b.addEventListener("loadedmetadata", function d() {
                b.yc(a);
                b.b.removeEventListener("loadedmetadata", d, !1)
            }, !1);
            this.b.src = this.O;
            this.b.load()
        }
    };
    h.tc = function(a) {
        wk(this);
        this.b.src = a;
        this.b.load();
        xk(this)
    };
    h.mb = function(a) {
        this.b.volume = a
    };
    h.rc = function() {
        return this.b.volume
    };
    h.Oa = function() {
        this.L = !1;
        Se(this.b.play, 0, this.b);
        this.G = !0;
        xk(this)
    };
    h.uc = function() {
        this.L = !0;
        this.b.pause()
    };
    h.sc = function() {
        return this.b.paused ? Hi() || qf ? this.b.currentTime < this.b.duration : !0 : !1
    };
    h.cc = function() {
        Gi() && this.b.webkitDisplayingFullscreen && this.b.webkitExitFullscreen()
    };
    h.ya = function() {
        return Si(this.b)
    };
    h.Aa = function(a) {
        this.b.currentTime = a
    };
    h.fa = function() {
        return this.b.currentTime
    };
    h.Na = function() {
        return isNaN(this.b.duration) ? -1 : this.b.duration
    };
    h.Pa = function() {
        return this.b.ended
    };
    h.wa = function() {
        return new L(this.b.offsetWidth, this.b.offsetHeight)
    };
    h.H = function() {
        this.xa();
        this.b = null;
        vk.X.H.call(this)
    };
    h.vc = function() {
        this.xa();
        this.g = new W(this);
        this.g.C(this.b, "canplay", this.xe);
        this.g.C(this.b, "ended", this.ze);
        this.g.C(this.b, "webkitbeginfullscreen", this.nb);
        this.g.C(this.b, "webkitendfullscreen", this.wc);
        this.g.C(this.b, "pause", this.Ce);
        this.g.C(this.b, "playing", this.Ee);
        this.g.C(this.b, "timeupdate", this.Fe);
        this.g.C(this.b, "volumechange", this.Ke);
        this.g.C(this.b, "error", this.Ac);
        this.g.C(this.b, pf ? "loadeddata" : "canplay", this.Ae);
        this.m = new Wj;
        this.g.C(this.m, "click", this.oe);
        Yj(this.m, this.b);
        this.A = new Qe(1E3);
        this.g.C(this.A, "tick", this.pe);
        this.A.start()
    };
    h.xa = function() {
        null != this.m && (ak(this.m), this.m = null);
        null != this.A && this.A.M();
        null != this.g && (this.g.M(), this.g = null);
        wk(this)
    };
    var wk = function(a) {
            a.F = !1;
            a.j = !1;
            a.G = !1;
            a.B = !1;
            a.h = 0;
            a.N = !1;
            a.T.clear();
            yk(a);
            yd(a.l)
        },
        zk = function(a) {
            a.j || (a.j = !0, yk(a), a.dispatchEvent("start"), !(Gi() && !O.ma() || ic && (!ic || !Ii(Di, 4)) || !O.Qa() && (B(G, "CrKey") || Li() || B(G, "Roku") || Ji() || B(G, "Xbox"))) || !ic || ic && Ii(Di, 3) || Gi() && (!Hi() || !Ii(Ci, 4)) || a.nb())
        };
    h = vk.prototype;
    h.xe = function() {
        var a;
        if (a = rf) a = G, a = !(a && (B(a, "SMART-TV") || B(a, "SmartTV")));
        a && !this.N && (this.Aa(.001), this.N = !0)
    };
    h.Ae = function() {
        this.F || (this.F = !0, this.G || yk(this), this.dispatchEvent("loaded"))
    };
    h.Ee = function() {
        this.dispatchEvent("play");
        Hi() || pf || zk(this)
    };
    h.Fe = function() {
        if (!this.j && (Hi() || pf)) {
            if (0 >= this.fa()) return;
            if (pf && this.Pa() && 1 == this.Na()) {
                this.Ac();
                return
            }
            zk(this)
        }
        if (Hi() || Ki()) {
            if (1.5 < this.fa() - this.h) {
                this.B = !0;
                this.Aa(this.h);
                return
            }
            this.B = !1;
            this.fa() > this.h && (this.h = this.fa())
        }
        var a = this.T;
        a.b[a.g] = this.b.currentTime;
        a.g = (a.g + 1) % a.h;
        this.dispatchEvent("timeUpdate")
    };
    h.Ke = function() {
        this.dispatchEvent("volumeChange")
    };
    h.Ce = function() {
        var a;
        this.j && Hi() && !this.L && 2 > Ak(this) ? (this.l = new Qe(250), this.g.C(this.l, "tick", this.we), this.l.start(), a = !0) : a = !1;
        a || this.dispatchEvent("pause")
    };
    h.ze = function() {
        var a = !0;
        if (Hi() || Ki()) a = this.h >= this.b.duration - 1.5;
        !this.B && a && this.dispatchEvent("end")
    };
    h.nb = function() {
        this.dispatchEvent("beginFullscreen")
    };
    h.wc = function() {
        this.dispatchEvent("endFullscreen")
    };
    h.Ac = function() {
        yk(this);
        this.dispatchEvent("error")
    };
    h.oe = function() {
        this.dispatchEvent("click")
    };
    h.pe = function() {
        var a = this.wa(),
            b = this.ya();
        if (a.width != this.K.width || a.height != this.K.height)!this.J && b ? this.nb() : this.J && !b && this.wc(), this.K = a, this.J = b
    };
    h.cd = function() {
        if (!this.j || !this.G && !this.F) {
            try {
                Kj(Hj.getInstance(), 16)
            } catch (a) {}
            wk(this);
            this.dispatchEvent("mediaLoadTimeout")
        }
    };
    h.we = function() {
        if (this.Pa() || !this.sc()) yd(this.l);
        else {
            var a = this.b.duration - this.b.currentTime,
                b = Ak(this);
            0 < b && (2 <= b || 2 > a) && (yd(this.l), this.Oa())
        }
    };
    var Ak = function(a) {
            var b;
            a: {
                for (b = a.b.buffered.length - 1; 0 <= b;) {
                    if (a.b.buffered.start(b) <= a.b.currentTime) {
                        b = a.b.buffered.end(b);
                        break a
                    }
                    b--
                }
                b = 0
            }
            return b - a.b.currentTime
        },
        xk = function(a) {
            a.I || (a.I = Se(a.cd, a.V, a))
        },
        yk = function(a) {
            a.I && (l.clearTimeout(a.I), a.I = null)
        };
    var Bk = function() {
        S.call(this);
        this.b = new W(this);
        Bd(O)
    };
    A(Bk, S);
    var Ck = function() {
        var a = ["video/mp4"],
            b = ["video/ogg"],
            c = new Bk;
        c.canPlayType = function(c) {
            return rb(a, c) ? "probably" : rb(b, c) ? "maybe" : ""
        };
        c.width = 0;
        c.height = 0;
        c.offsetWidth = 0;
        c.offsetHeight = 0;
        return c
    };
    h = Bk.prototype;
    h.currentTime = 0;
    h.volume = 1;
    h.src = "";
    h.va = null;
    h.Xa = null;
    h.H = function() {
        this.b.M()
    };
    h.Je = function(a) {
        var b = null,
            c = null;
        switch (a.type) {
            case "loadeddata":
                b = "Loaded";
                break;
            case "playing":
                b = "Playing";
                c = "#00f";
                break;
            case "pause":
                b = "Paused";
                break;
            case "ended":
                b = "Ended", c = "#000"
        }
        b && this.Xa && (this.Xa.innerText = b);
        c && this.va && (this.va.style.backgroundColor = c)
    };
    I && J(8);
    var Dk = function() {
        throw Error("Do not instantiate directly");
    };
    Dk.prototype.b = null;
    Dk.prototype.getContent = function() {
        return this.content
    };
    Dk.prototype.toString = function() {
        return this.content
    };
    var Ek = function() {
        Dk.call(this)
    };
    A(Ek, Dk);
    (function(a) {
        function b(a) {
            this.content = a
        }
        b.prototype = a.prototype;
        return function(a, d) {
            var e = new b(String(a));
            void 0 !== d && (e.b = d);
            return e
        }
    })(Ek);
    var Fk = {},
        Gk = function(a, b) {
            var c = "key_" + a + ":" + b,
                d = Fk[c];
            if (void 0 === d || 0 > d) Fk[c] = 0;
            else if (0 == d) throw Error('Encountered two active delegates with the same priority ("' + a + ":" + b + '").');
        };
    (function(a) {
        function b(a) {
            this.content = a
        }
        b.prototype = a.prototype;
        return function(a, d) {
            var e = String(a);
            if (!e) return "";
            e = new b(e);
            void 0 !== d && (e.b = d);
            return e
        }
    })(Ek);
    Gk("a", "");
    Gk("a", "redesign2014q4");
    Gk("b", "");
    Gk("b", "redesign2014q4");
    var Hk = function(a, b, c) {
        if (null == a || !md(bd(a), a)) throw Tj(Sj, null, "containerElement", "element");
        this.l = a;
        this.g = this.b = null;
        this.j = b;
        this.m = c;
        this.h = null;
        this.b = jd("div", {
            style: "display:none;"
        });
        var d;
        a = Bd(O);
        if (Cd(a, "useVideoElementMock")) {
            a = Ck();
            b = jd("div", {
                style: "position:absolute;width:100%;height:100%;top:0px;left:0px;"
            });
            for (d in a) b[d] = a[d];
            a.va = jd("div", {
                style: "position:absolute;width:100%;height:100%;top:0px;left:0px;background-color:#000"
            });
            a.Xa = jd("p", {
                style: "position:absolute;top:25%;margin-left:10px;font-size:24px;color:#fff;"
            });
            a.va.appendChild(a.Xa);
            b.appendChild(a.va);
            a.b.C(a, ["loadeddata", "playing", "pause", "ended"], a.Je);
            d = b
        } else d = jd("video", {
            style: "background-color:#000;position:absolute;width:100%;height:100%;",
            title: "Advertisement"
        });
        d.setAttribute("webkit-playsinline", !0);
        this.g = d;
        this.l.appendChild(this.b);
        this.b.appendChild(this.g);
        this.j && (d = jd("div", {
            id: this.j,
            style: "display:none;background-color:#000;position:absolute;width:100%;height:100%;"
        }), this.b.appendChild(d));
        this.m && (this.h = jd("div", {
                style: "position:absolute;width:100%;height:100%;"
            }),
            this.b.appendChild(this.h))
    };
    A(Hk, wd);
    Hk.prototype.H = function() {
        ld(this.b);
        Hk.X.H.call(this)
    };
    var Jk = function(a) {
        S.call(this);
        this.J = "ima-chromeless-video";
        var b = null;
        null != a && (w(a) ? this.J = a : b = a);
        this.K = new W(this);
        this.l = null;
        this.j = !1;
        this.aa = this.wa();
        this.$ = this.ya();
        this.F = -1;
        this.O = !1;
        this.m = -1;
        this.g = this.N = this.G = null;
        this.da = "";
        this.h = !1;
        this.V = null != b;
        this.ca = this.I = this.T = this.b = null;
        this.A = void 0;
        this.B = this.ba = null;
        this.o = 0;
        this.V ? (this.h = !0, this.b = b, this.A = 2) : (a = z(this.dd, this), Ik ? a() : (sb.push(a), a = document.createElement("script"), a.src = "https://www.youtube.com/iframe_api", b =
            document.getElementsByTagName("script")[0], b.parentNode.insertBefore(a, b)))
    };
    A(Jk, tk);
    var Kk = {
            el: "adunit",
            controls: 0,
            html5: 1,
            playsinline: 1,
            ps: "gvn",
            showinfo: 0
        },
        sb = [],
        Ik = !1;
    h = Jk.prototype;
    h.Hc = function(a) {
        this.g = a
    };
    h.tc = function(a, b) {
        null !== a && (this.da = a, this.h ? Lk(this, a, b) : (this.G = a, this.N = b))
    };
    h.mb = function(a) {
        this.V ? this.dispatchEvent("volumeChange") : this.h ? (a = Math.min(Math.max(100 * a, 0), 100), this.b.setVolume(a), this.m = -1, this.dispatchEvent("volumeChange")) : this.m = a
    };
    h.rc = function() {
        return this.h ? this.b.getVolume() / 100 : this.m
    };
    h.Oa = function() {
        if (!ka(va(this.da))) {
            if (!this.j) {
                Mk(this);
                var a = 15E3;
                null != this.g && 0 < this.g.b && (a = this.g.b);
                this.ka = Se(this.na, a, this)
            }
            this.h ? (this.O = !1, !this.j && this.g && this.g.g ? this.b.loadVideoByPlayerVars(this.ba) : this.b.playVideo()) : this.O = !0
        }
    };
    h.uc = function() {
        this.h && this.j && this.b.pauseVideo()
    };
    h.sc = function() {
        return this.h ? 2 == this.b.getPlayerState(this.A) : !1
    };
    h.cc = function() {};
    h.ya = function() {
        var a = document.getElementById(this.J);
        return a ? Si(a) : !1
    };
    h.Aa = function(a) {
        this.h ? this.b.seekTo(a, !1) : this.F = a
    };
    h.fa = function() {
        return this.h ? this.b.getCurrentTime(this.A) : -1
    };
    h.Na = function() {
        return this.h && this.j ? this.b.getDuration(this.A) : -1
    };
    h.ec = function() {
        return Ib(xj)
    };
    h.Pa = function() {
        return this.h ? 0 == this.b.getPlayerState(this.A) : !1
    };
    h.wa = function() {
        var a = document.getElementById(this.J);
        return a ? new L(a.offsetWidth, a.offsetHeight) : new L(0, 0)
    };
    h.qe = function() {
        var a = this.wa(),
            b = this.ya();
        if (a.width != this.aa.width || a.height != this.aa.height)!this.$ && b ? this.dispatchEvent("beginFullscreen") : this.$ && !b && this.dispatchEvent("endFullscreen"), this.aa = a, this.$ = b
    };
    h.vc = function() {
        this.T = z(this.Bc, this);
        this.I = z(this.rb, this);
        this.ca = z(this.Cc, this);
        this.V && (this.b.addEventListener("onAdStateChange", this.I), this.b.addEventListener("onReady", this.T), this.b.addEventListener("onStateChange", this.I), this.b.addEventListener("onVolumeChange", this.ca));
        this.L = new Qe(1E3);
        this.K.C(this.L, "tick", this.qe);
        this.L.start()
    };
    h.xa = function() {
        this.V && (this.b.removeEventListener("onAdStateChange", this.I), this.b.removeEventListener("onReady", this.T), this.b.removeEventListener("onStateChange", this.I), this.b.removeEventListener("onVolumeChange", this.ca));
        null != this.L && this.L.M()
    };
    h.dd = function() {
        var a = this.J,
            b = {
                playerVars: Ob(Kk),
                events: {
                    cardstatechange: z(this.ye, this),
                    onError: z(this.De, this),
                    onReady: z(this.Bc, this),
                    onAdStateChange: z(this.rb, this),
                    onStateChange: z(this.rb, this),
                    onVolumeChange: z(this.Cc, this)
                }
            },
            c = aa("YT");
        this.b = null != c && null != c.Player ? new c.Player(a, b) : null
    };
    var Lk = function(a, b, c) {
        var d = {};
        if (null != a.g) {
            var e = a.g.l;
            null != e && (d.agcid = e);
            e = a.g.h;
            null != e && (d.adformat = e);
            e = a.g.j;
            null != e && (d.ad_query_id = e);
            (e = a.g.w) && (d.cta_conversion_urls = e);
            d.iv_load_policy = a.g.o ? 1 : 3;
            a.g.m && (d.noiba = 1);
            a.g.D && (d.utpsa = 1)
        }
        null != b ? Dj(yj, b) ? (e = b.match(/yt_vid\/([a-zA-Z0-9_-]{11})/), e = null != e && 1 < e.length ? e[1] : null) : e = null != b && Dj(zj, b) ? rk(b) : null : e = null;
        null === e ? d.url_encoded_third_party_media = "url=" + encodeURIComponent(b) + "&type=" + encodeURIComponent(null === c ? "" : c) : d.videoId =
            e;
        a.j = !1;
        a.g && a.g.g ? (a.ba = d, a.b.preloadVideoByPlayerVars(a.ba)) : a.b.cueVideoByPlayerVars(d);
        a.dispatchEvent("loaded")
    };
    h = Jk.prototype;
    h.De = function() {
        this.dispatchEvent("error")
    };
    h.Bc = function() {
        this.h = !0;
        this.B && this.ia(this.B.videoId, this.B.cardsXml, this.B.trackingXml); - 1 != this.m && (this.mb(this.m), this.m = -1);
        null != this.G && (Lk(this, this.G, this.N), this.N = this.G = null); - 1 != this.F && (this.Aa(this.F), this.F = -1);
        this.O && this.Oa()
    };
    h.ye = function() {
        this.dispatchEvent("cardsStateChange")
    };
    h.rb = function(a) {
        switch (a.data) {
            case 0:
                this.j ? this.dispatchEvent("end") : this.dispatchEvent("error");
                break;
            case 1:
                this.j || (Mk(this), this.j = !0, this.o = 0, this.dispatchEvent("start"));
                this.dispatchEvent("play");
                Nk(this);
                this.l = new Qe(100);
                this.K.C(this.l, "tick", this.ja);
                this.l.start();
                break;
            case 2:
                this.dispatchEvent("pause"), Nk(this)
        }
    };
    h.Cc = function() {
        this.dispatchEvent("volumeChange")
    };
    var Nk = function(a) {
            a.K.Ba(a.l, "tick", a.ja);
            null != a.l && (Re(a.l), a.l = null)
        },
        Mk = function(a) {
            null != a.ka && l.clearTimeout(a.ka)
        };
    Jk.prototype.ja = function() {
        if (nf || Ki()) {
            if (1.5 < this.fa() - this.o) {
                this.h && this.b.seekTo(this.o, !0);
                return
            }
            this.fa() > this.o && (this.o = this.fa())
        }
        this.dispatchEvent("timeUpdate")
    };
    Jk.prototype.na = function() {
        this.dispatchEvent("mediaLoadTimeout")
    };
    Jk.prototype.ia = function(a, b, c) {
        if (b || c) this.h ? this.b.addInfoCardXml(a, b, c) : this.B = {
            videoId: a,
            cardsXml: b,
            trackingXml: c
        }
    };
    Jk.prototype.H = function() {
        Nk(this);
        Mk(this);
        this.xa();
        this.h = !1;
        this.K.M();
        this.F = -1;
        this.N = null;
        this.O = !1;
        this.G = null;
        this.m = -1;
        this.T = this.b = this.g = null;
        this.j = !1;
        this.da = "";
        Jk.X.H.call(this)
    };
    r("onYouTubeIframeAPIReady", function() {
        Ik = !0;
        E(sb, function(a) {
            a()
        });
        tb()
    }, window);
    var Ok = function(a) {
        S.call(this);
        this.b = a || "goog_" + ya++;
        this.h = []
    };
    A(Ok, S);
    Ok.prototype.g = !1;
    Ok.prototype.connect = function() {
        for (this.g = !0; 0 != this.h.length;) {
            var a = this.h.shift();
            this.sendMessage(a.name, a.type, a.data)
        }
    };
    Ok.prototype.send = function(a, b, c) {
        this.g ? this.sendMessage(a, b, c) : this.h.push({
            name: a,
            type: b,
            data: c
        })
    };
    var Pk = function(a, b, c, d, e) {
        N.call(this, a);
        this.U = b;
        this.P = c;
        this.Ma = d;
        this.Dc = e
    };
    A(Pk, N);
    Pk.prototype.toString = function() {
        return ""
    };
    var Qk = function(a, b) {
        Ok.call(this, b);
        this.j = a;
        this.ea = null;
        this.l = new W(this);
        this.l.C(M(), "message", this.m)
    };
    A(Qk, Ok);
    var Rk = function(a) {
        if (null == a || !w(a) || 0 != a.lastIndexOf("ima://", 0)) return null;
        a = a.substr(6);
        try {
            return Fd(a)
        } catch (b) {
            return null
        }
    };
    Qk.prototype.sendMessage = function(a, b, c) {
        null != this.ea && null != this.ea.postMessage && this.ea.postMessage(Sk(this, a, b, c), "*");
        null != this.ea && null == this.ea.postMessage && Kj(Hj.getInstance(), 11)
    };
    Qk.prototype.H = function() {
        this.l.M();
        Qk.X.H.call(this)
    };
    Qk.prototype.m = function(a) {
        a = a.g;
        var b = Rk(a.data);
        if (Tk(this, b)) {
            if (null == this.ea) this.ea = a.source, this.g || this.connect();
            else if (this.ea != a.source) return;
            Tk(this, b) && this.dispatchEvent(new Pk(b.name, b.type, b.data || {}, b.sid, a.origin))
        }
    };
    var Sk = function(a, b, c, d) {
            var e = {};
            e.name = b;
            e.type = c;
            null != d && (e.data = d);
            e.sid = a.b;
            e.channel = a.j;
            return "ima://" + Hd(e)
        },
        Tk = function(a, b) {
            if (null == b) return !1;
            var c = b.channel;
            if (null == c || c != a.j) return !1;
            c = b.sid;
            return null == c || "*" != a.b && c != a.b ? !1 : !0
        };
    var Uk = function(a, b) {
        S.call(this);
        this.j = a;
        this.h = b;
        this.b = {};
        this.g = new W(this);
        this.g.C(M(), "message", this.l)
    };
    A(Uk, S);
    Uk.prototype.send = function(a) {
        var b = a.g;
        this.b.hasOwnProperty(b) && this.b[b].send(a.type, a.U, a.P)
    };
    var Wk = function(a, b, c, d) {
        a.b.hasOwnProperty(b) || (c = new Qk(b, c), a.g.C(c, a.j, function(a) {
            this.dispatchEvent(new Vk(a.type, a.U, a.P, a.Ma, a.Dc, b))
        }), c.ea = d, c.connect(), a.b[b] = c)
    };
    Uk.prototype.H = function() {
        this.g.M();
        for (var a in this.b) yd(this.b[a]);
        Uk.X.H.call(this)
    };
    Uk.prototype.l = function(a) {
        a = a.g;
        var b = Rk(a.data);
        if (null != b) {
            var c = b.channel;
            if (this.h && !this.b.hasOwnProperty(c)) {
                var d = b.sid;
                Wk(this, c, d, a.source);
                this.dispatchEvent(new Vk(b.name, b.type, b.data || {}, d, a.origin, c))
            }
        }
    };
    var Vk = function(a, b, c, d, e, f) {
        Pk.call(this, a, b, c, d, e);
        this.g = f
    };
    A(Vk, Pk);
    var Yk = function() {
        var a = aa("google.ima.gptProxyInstance", M());
        if (null != a) return a;
        W.call(this);
        this.h = new Uk("gpt", !0);
        xd(this, ha(yd, this.h));
        this.C(this.h, "gpt", this.m);
        this.b = null;
        Xk() || M().top === M() || (this.b = new Uk("gpt", !1), xd(this, ha(yd, this.b)), this.C(this.b, "gpt", this.l))
    };
    A(Yk, W);
    var Xk = function() {
            return !!aa("googletag.cmd", M())
        },
        Zk = function() {
            var a = aa("googletag.console", M());
            return null != a ? a : null
        };
    Yk.prototype.m = function(a) {
        var b = a.Dc,
            c = uc("//imasdk.googleapis.com"),
            b = uc(b);
        if (c[3] == b[3] && c[4] == b[4])
            if (null != this.b) Wk(this.b, a.g, a.Ma, M().parent), null != this.b && this.b.send(a);
            else if (c = a.P, null != c && n(c.scope)) {
            var b = c.scope,
                c = c.args,
                d;
            if ("proxy" == b) c = a.U, "isGptPresent" == c ? d = Xk() : "isConsolePresent" == c && (d = null != Zk());
            else if (Xk())
                if ("pubads" == b || "companionAds" == b) {
                    d = a.U;
                    var e, f = M().googletag;
                    if (null != f && null != f[b] && (f = f[b](), null != f && (d = f[d], null != d))) try {
                        e = d.apply(f, c)
                    } catch (g) {}
                    d = e
                } else if ("console" ==
                b) {
                if (f = a.U, e = Zk(), null != e && (f = e[f], null != f)) try {
                    f.apply(e, c)
                } catch (k) {}
            } else if (null === b) {
                e = a.U;
                d = M();
                if (rb(["googleGetCompanionAdSlots", "googleSetCompanionAdContents"], e) && (e = d[e], null != e)) try {
                    f = e.apply(d, c)
                } catch (m) {}
                d = f
            }
            n(d) && (a.P.returnValue = d, this.h.send(a))
        }
    };
    Yk.prototype.l = function(a) {
        this.h.send(a)
    };
    var $k = function(a, b, c, d, e, f, g, k, m) {
        this.h = a;
        this.j = m;
        this.l = b;
        this.w = c;
        this.m = g;
        this.o = d;
        this.D = e;
        this.b = f;
        this.g = k
    };
    var bl = function(a, b) {
            var c = Array.prototype.slice.call(arguments),
                d = c.shift();
            if ("undefined" == typeof d) throw Error("[goog.string.format] Template required");
            return d.replace(/%([0\-\ \+]*)(\d+)?(\.(\d+))?([%sfdiu])/g, function(a, b, d, k, m, p, t, D) {
                if ("%" == p) return "%";
                var q = c.shift();
                if ("undefined" == typeof q) throw Error("[goog.string.format] Not enough arguments");
                arguments[0] = q;
                return al[p].apply(null, arguments)
            })
        },
        al = {
            s: function(a, b, c) {
                return isNaN(c) || "" == c || a.length >= c ? a : a = -1 < b.indexOf("-", 0) ? a + Array(c -
                    a.length + 1).join(" ") : Array(c - a.length + 1).join(" ") + a
            },
            f: function(a, b, c, d, e) {
                d = a.toString();
                isNaN(e) || "" == e || (d = parseFloat(a).toFixed(e));
                var f;
                f = 0 > a ? "-" : 0 <= b.indexOf("+") ? "+" : 0 <= b.indexOf(" ") ? " " : "";
                0 <= a && (d = f + d);
                if (isNaN(c) || d.length >= c) return d;
                d = isNaN(e) ? Math.abs(a).toString() : Math.abs(a).toFixed(e);
                a = c - d.length - f.length;
                return d = 0 <= b.indexOf("-", 0) ? f + d + Array(a + 1).join(" ") : f + Array(a + 1).join(0 <= b.indexOf("0", 0) ? "0" : " ") + d
            },
            d: function(a, b, c, d, e, f, g, k) {
                return al.f(parseInt(a, 10), b, c, d, 0, f, g, k)
            }
        };
    al.i = al.d;
    al.u = al.d;
    var el = function(a, b) {
        S.call(this);
        this.j = new W(this);
        this.A = !1;
        this.B = "goog_" + ya++;
        this.m = new F;
        var c = this.B,
            d = O.ma() ? cl() + bl("//imasdk.googleapis.com/js/core/admob/bridge_%s.html", O.hb()) : cl() + bl("//imasdk.googleapis.com/js/core/bridge3.101.4_%s.html", O.hb()),
            e;
        a: {
            var f = window;
            try {
                do {
                    try {
                        if (0 == f.location.href.indexOf(d) || 0 == f.document.referrer.indexOf(d)) {
                            e = !0;
                            break a
                        }
                    } catch (g) {}
                    f = f.parent
                } while (f != f.top)
            } catch (k) {}
            e = !1
        }
        e && (d += "?f=" + c);
        c = jd("iframe", {
            src: d + "#" + c,
            style: "border:0; opacity:0; margin:0; padding:0; position:relative;"
        });
        ni(this.j, c, "load", this.ed, void 0);
        a.appendChild(c);
        this.g = c;
        this.l = dl(this);
        this.o = b;
        this.b = this.o.h;
        this.h = null;
        this.j.C(this.l, "mouse", this.F);
        this.j.C(this.l, "touch", this.qd);
        null != this.b && (this.j.C(this.l, "displayContainer", this.nd), this.j.C(this.l, "videoDisplay", this.od), this.j.C(this.b, Ib(uk), this.Ie));
        c = M();
        d = aa("google.ima.gptProxyInstance", c);
        null == d && (d = new Yk, r("google.ima.gptProxyInstance", d, c))
    };
    A(el, S);
    var dl = function(a, b) {
        var c = b || "*",
            d = a.m.get(c);
        null == d && (d = new Qk(a.B, c), a.A && (d.ea = nd(a.g), d.connect()), Tb(a.m, c, d));
        return d
    };
    el.prototype.H = function() {
        this.j.M();
        null !== this.h && (this.h.M(), this.h = null);
        Db(this.m.sa(!1), function(a) {
            a.M()
        });
        this.m.clear();
        ld(this.g);
        el.X.H.call(this)
    };
    var cl = function() {
        return "https:" == document.location.protocol ? "https:" : "http:"
    };
    el.prototype.F = function(a) {
        var b = a.P,
            c = Xd(this.g),
            d = document.createEvent("MouseEvent");
        d.initMouseEvent(a.U, !0, !0, window, b.detail, b.screenX, b.screenY, b.clientX + c.x, b.clientY + c.y, b.ctrlKey, b.altKey, b.shiftKey, b.metaKey, b.button, null);
        if (!rf || Hi() || 0 == document.webkitIsFullScreen) this.g.blur(), window.focus();
        this.g.dispatchEvent(d)
    };
    var fl = function(a, b) {
        var c = Xd(a.g),
            d = nb(b, function(a) {
                return document.createTouch(window, this.g, a.identifier, a.pageX + c.x, a.pageY + c.y, a.screenX, a.screenY)
            }, a);
        return document.createTouchList.apply(document, d)
    };
    h = el.prototype;
    h.qd = function(a) {
        var b = a.P,
            c = Xd(this.g),
            d = document.createEvent("TouchEvent");
        d.initTouchEvent(a.U, !0, !0, window, b.detail, b.screenX, b.screenY, b.clientX + c.x, b.clientY + c.y, b.ctrlKey, b.altKey, b.shiftKey, b.metaKey, fl(this, b.touches), fl(this, b.targetTouches), fl(this, b.changedTouches), b.scale, b.rotation);
        this.g.dispatchEvent(d)
    };
    h.od = function(a) {
        if (null != this.b) {
            var b = a.P;
            switch (a.U) {
                case "startTracking":
                    this.b.vc();
                    break;
                case "stopTracking":
                    this.b.xa();
                    break;
                case "exitFullscreen":
                    this.b.cc();
                    break;
                case "play":
                    this.b.Oa();
                    break;
                case "pause":
                    this.b.uc();
                    break;
                case "load":
                    this.b.tc(b.videoUrl, b.mimeType);
                    break;
                case "setCurrentTime":
                    this.b.Aa(b.currentTime);
                    break;
                case "setPlaybackOptions":
                    a = b.playbackOptions, this.b.Hc(new $k(a.adFormat, a.adSenseAgcid, a.ctaAnnotationTrackingEvents, a.showAnnotations, a.viewCountsDisabled, a.loadVideoTimeout,
                        a.ibaDisabled, a.enablePreloading, a.adQemId))
            }
        }
    };
    h.Ie = function(a) {
        var b = {};
        switch (a.type) {
            case "beginFullscreen":
                a = "fullscreen";
                break;
            case "endFullscreen":
                a = "exitFullscreen";
                break;
            case "click":
                a = "click";
                break;
            case "end":
                a = "end";
                break;
            case "error":
                a = "error";
                break;
            case "loaded":
                a = "loaded";
                break;
            case "mediaLoadTimeout":
                a = "mediaLoadTimeout";
                break;
            case "pause":
                a = "pause";
                b.ended = this.b.Pa();
                break;
            case "play":
                a = "play";
                break;
            case "skip":
                a = "skip";
                break;
            case "start":
                a = "start";
                break;
            case "timeUpdate":
                a = "timeupdate";
                b.currentTime = this.b.fa();
                b.duration = this.b.Na();
                break;
            case "volumeChange":
                a = "volumeChange";
                b.volume = this.b.rc();
                break;
            default:
                return
        }
        this.l.send("videoDisplay", a, b)
    };
    h.nd = function(a) {
        switch (a.U) {
            case "showVideo":
                null != this.h ? ak(this.h) : (this.h = new Wj, this.j.C(this.h, "click", this.He));
                Yj(this.h, gl(this.o));
                a = this.o;
                null != a.b && (a = a.b.b, null != a && (a.style.display = "block"));
                break;
            case "hide":
                null !== this.h && (this.h.M(), this.h = null), a = this.o, null != a.b && (a = a.b.b, null != a && (a.style.display = "none"))
        }
    };
    h.He = function() {
        this.l.send("displayContainer", "videoClick")
    };
    h.ed = function() {
        Db(this.m.sa(!1), function(a) {
            a.ea = nd(this.g);
            a.connect()
        }, this);
        this.A = !0
    };
    var hl = function(a, b, c, d, e) {
        if (!(e || null != a && md(bd(a), a))) throw Tj(Sj, null, "containerElement", "element");
        this.D = !1;
        this.w = a;
        e = null != b || null != d;
        if (!e && O.za()) throw Tj(Qj, null, "Custom video element was not provided even though the setting restrictToCustomPlayback is set to true.");
        var f = e,
            g = !1;
        O.za() || (O.ma() ? !Mi() : Hi() || ic && (!ic || !Ii(Di, 4)) || ic && !yi(41351081) || B(G, "CrKey") || Li() || B(G, "Roku") || Ji() || B(G, "Xbox")) && e || (Mi() && (g = !0), f = !1);
        this.o = f;
        this.L = (this.K = g) || f && null != d;
        e = jd("div", {
            style: "position:absolute"
        });
        a.insertBefore(e, a.firstChild);
        this.g = e;
        this.b = !this.o && this.g && Fi() ? new Hk(this.g, null, !0) : null;
        a = null;
        this.o ? b ? a = new vk(b) : d && (a = new Jk(d)) : this.b && (a = new vk(this.b.g));
        this.l = (this.h = a) ? c || null : null;
        this.A = null != this.l;
        Kj(Hj.getInstance(), 8, {
            enabled: this.o,
            yt: null != d,
            customClick: null != this.l
        });
        null === this.g ? (b = this.w, O.b = b) : this.o && b ? y(b.getBoundingClientRect) || (b = this.w, O.b = b) : b = this.g;
        this.F = b;
        this.m = null != this.g ? new el(this.g, this) : null
    };
    hl.prototype.I = function() {
        this.D = !0;
        if (null != this.b) {
            var a = this.b.g;
            Fi() && a.load()
        }
    };
    hl.prototype.G = function() {
        yd(this.b);
        yd(this.m);
        yd(this.h);
        ld(this.g)
    };
    var gl = function(a) {
        return a.A && a.l ? a.l : null != a.b ? a.b.h : null
    };
    hl.prototype.j = function() {
        return this.o
    };
    hl.prototype.J = function() {
        return this.K
    };
    hl.prototype.B = function() {
        return this.L
    };
    var il = gc && "srcdoc" in document.createElement("iframe"),
        jl = fc || gc || I && J(11),
        ol = function(a, b) {
            I && J(7) && !J(10) && 6 > kl() && ll(b) && (b = ml(b));
            var c = function() {
                    a.contentWindow.goog_content = b;
                    a.contentWindow.location.replace("javascript:window.goog_content")
                },
                d;
            if (d = I) {
                var e;
                try {
                    e = Da(a.contentWindow)
                } catch (f) {
                    e = !1
                }
                d = !e
            }
            d ? nl(a, c) : c()
        },
        kl = function() {
            var a = navigator.userAgent.match(/Trident\/([0-9]+.[0-9]+)/);
            return a ? parseFloat(a[1]) : 0
        },
        pl = 0,
        nl = function(a, b) {
            var c = "goog_rendering_callback" + pl++;
            window[c] = b;
            a.src =
                "javascript:'<script>(function() {document.domain = \"" + document.domain + '";var continuation = window.parent.' + c + ";window.parent." + c + " = null;continuation();})()\x3c/script>'"
        },
        ll = function(a) {
            for (var b = 0; b < a.length; ++b)
                if (127 < a.charCodeAt(b)) return !0;
            return !1
        },
        ml = function(a) {
            a = unescape(encodeURIComponent(a));
            for (var b = Math.floor(a.length / 2), c = [], d = 0; d < b; ++d) c[d] = String.fromCharCode(256 * a.charCodeAt(2 * d + 1) + a.charCodeAt(2 * d));
            1 == a.length % 2 && (c[b] = a.charAt(a.length - 1));
            return c.join("")
        };
    var ql = function(a, b, c) {
        this.l = a;
        this.b = b;
        this.o = "";
        this.A = 0;
        this.h = this.g = null;
        this.G = c;
        this.m = null;
        this.j = ""
    };
    A(ql, S);
    ql.prototype.F = function(a) {
        a = a.g.data;
        try {
            var b = Fd(a)
        } catch (c) {
            return
        }
        var d = b.session;
        if (null != d && this.j == d) {
            if ("friendlyReady" == b.type) {
                if (Ei()) this.o = this.b.currentSrc, this.A = this.b.currentTime;
                else {
                    var b = this.l.w,
                        d = "border: 0; margin: 0; padding: 0;position: absolute; ",
                        e = ae(this.b),
                        d = d + ("width:" + e.width + "px; "),
                        d = d + ("height:" + e.height + "px;");
                    this.b = jd("VIDEO", {
                        style: d
                    });
                    b.appendChild(this.b)
                }
                b = this.l.w;
                d = "border: 0; margin: 0; padding: 0;position: absolute; ";
                e = ae(this.b);
                d += "width:" + e.width +
                    "px; ";
                d += "height:" + e.height + "px;";
                this.h = jd("DIV", {
                    style: d
                });
                b.appendChild(this.h);
                try {
                    this.g.contentWindow.loader.initFriendly(this.b, this.h)
                } catch (f) {
                    b = {
                        type: "error"
                    }, b.session = this.j, b = Hd(b), window.postMessage(b, "*")
                }
            }
            this.G.send("vpaid", "", a)
        }
    };
    ql.prototype.H = function() {
        S.X.H.call(this);
        yd(this.B);
        this.B = null;
        ld(this.h);
        this.h = null;
        ld(this.g);
        this.g = null;
        Ei() ? (this.b.src = this.o, this.b.currentTime = this.A) : (ld(this.b), this.b = null)
    };
    var Z = function(a, b, c, d, e) {
        S.call(this);
        this.b = a;
        this.B = b;
        this.j = null;
        this.K = e;
        this.F = !1;
        this.V = 1;
        this.da = c;
        this.T = this.L = this.J = -1;
        this.h = this.g = null;
        this.m = new dk;
        this.ba = !1;
        this.G = new F;
        this.I = this.$ = !1;
        this.A = null;
        this.O = d && null != this.b.l;
        this.N = new W(this);
        this.N.C(this.K, "adsManager", this.ca)
    };
    A(Z, S);
    Z.prototype.ca = function(a) {
        switch (a.U) {
            case "error":
                a = a.P;
                var b = new zd(rl(a));
                this.ba ? (this.dispatchEvent(b), this.g && Ui(Pi(), null, this.g.b.adQueryId), this.g = null) : this.m.g.push(b);
                Kj(Hj.getInstance(), 7, {
                    error: a.errorCode
                }, !0);
                break;
            case "contentPauseRequested":
                b = this.b.h;
                this.b.j() && null != this.j && this.j.restoreCustomPlaybackStateOnAdBreakComplete && null != b.Gc && b.Gc();
                this.l(a.U, a.P);
                break;
            case "contentResumeRequested":
                a = z(Z.prototype.l, this, a.U, a.P);
                b = this.b.h;
                this.b.j() && null != this.j && this.j.restoreCustomPlaybackStateOnAdBreakComplete &&
                    null != b.Ec ? b.Ec(a) : a();
                break;
            case "remainingTime":
                b = a.P;
                this.J = b.currentTime;
                this.L = b.duration;
                this.T = b.remainingTime;
                break;
            case "skip":
            case "notExtended":
                this.l(a.U, a.P);
                break;
            case "log":
                var b = a.P,
                    c = b.adData;
                this.l(a.U, c, b.logData);
                break;
            case "companionBackfill":
                a = aa("window.google_show_companion_ad");
                null != a && a();
                break;
            case "skipshown":
                this.F = !0;
                this.l(a.U, a.P);
                break;
            case "vpaidEvent":
                b = a.P;
                switch (b.vpaidEventType) {
                    case "createFriendlyIframe":
                        a = this.A = new ql(this.b, this.aa, this.K);
                        a.j = b.session;
                        b = "about:self";
                        I && (b = "");
                        a.g = jd("IFRAME", {
                            src: b,
                            allowtransparency: !0,
                            background: "transparent",
                            style: "border:0; opacity:0; margin:0; overflow:hidden;padding:0; position: absolute;"
                        });
                        a.l.w.appendChild(a.g);
                        b = '<body><script src="//imasdk.googleapis.com/js/sdkloader/loader.js">\x3c/script><script>';
                        b += 'loader = new VPAIDLoader(false, "' + a.j + '");';
                        b += "\x3c/script>";
                        b += "</body>";
                        null == a.m && (a.m = new W(a));
                        a.m.C(window, "message", a.F);
                        a = a.g;
                        il ? a.srcdoc = b : jl ? (a = a.contentWindow.document, a.open("text/html",
                            "replace"), a.write(b), a.close()) : ol(a, b);
                        break;
                    case "destroryFriendlyIframe":
                        null != this.A && (this.A.M(), this.A = null)
                }
                break;
            case "skippableStateChanged":
                b = a.P;
                c = b.adData;
                null != c.skippable && (this.F = c.skippable);
                this.l(a.U, a.P);
                break;
            default:
                this.l(a.U, a.P)
        }
    };
    Z.prototype.l = function(a, b, c) {
        if (null == b.companions) {
            var d = this.G.get(b.adId);
            b.companions = null != d ? d : []
        }
        this.g = d = null != b.adData ? new Y(b.adData) : null;
        switch (a) {
            case "adBreakReady":
            case "trackingUrlPinged":
                a = new V(a, null, b);
                break;
            case "adMetadata":
                a = null;
                null != b.adCuePoints && (a = new Nj(b.adCuePoints));
                a = new Vj(d, a);
                break;
            case "allAdsCompleted":
                this.g = null;
                this.$ = !0;
                a = new V(a, d);
                break;
            case "contentPauseRequested":
                this.I = !1;
                a = new V(a, d);
                break;
            case "contentResumeRequested":
                this.g = null;
                this.I = !0;
                a = new V(a,
                    d);
                break;
            case "loaded":
                this.J = 0;
                this.L = d.lb();
                this.T = d.lb();
                Ui(Pi(), z(this.jd, this), d.b.adQueryId);
                a = new V(a, d, b.adData);
                break;
            case "start":
                Tb(this.G, b.adId, b.companions);
                null != gl(this.b) && (null != this.h ? ak(this.h) : (this.h = new Wj, this.N.C(this.h, "click", this.Be)), Yj(this.h, gl(this.b)));
                a = new V(a, d);
                break;
            case "complete":
                null != this.h && ak(this.h);
                Ui(Pi(), null, d.b.adQueryId);
                this.g = null;
                Wb(this.G, b.adId);
                a = new V(a, d);
                break;
            case "log":
                b = {
                    adError: rl(c)
                };
                a = new V(a, d, b);
                break;
            case "urlNavigationRequested":
                a =
                    new V(a, d, b.urlNavigationData);
                break;
            default:
                a = new V(a, d)
        }
        this.dispatchEvent(a);
        this.$ && this.I && this.jc()
    };
    var rl = function(a) {
            var b = new vd(a.type, a.errorMessage, a.errorCode);
            null != a.innerError && (b.g = Error(a.innerError));
            return b
        },
        sl = function(a, b, c) {
            a.K.send("adsManager", b, c)
        };
    h = Z.prototype;
    h.zc = function() {
        sl(this, "contentTimeUpdate", {
            currentTime: this.aa.currentTime
        })
    };
    h.Zd = function() {
        sl(this, "sendImpressionUrls")
    };
    h.Wd = function(a, b, c) {
        if (this.m.isEmpty()) this.ba = !0, this.kc(a, b, c), sl(this, "init", {
            width: a,
            height: b,
            viewMode: c
        });
        else {
            for (; !this.m.isEmpty();) b = a = this.m, 0 == b.b.length && (b.b = b.g, b.b.reverse(), b.g = []), a = a.b.pop(), this.dispatchEvent(a);
            this.M()
        }
    };
    h.ve = function() {
        return this.b.j()
    };
    h.ue = function() {
        return this.O
    };
    h.Ud = function() {
        return this.T
    };
    h.Rd = function() {
        return this.F
    };
    h.jd = function() {
        var a = null != this.g ? this.g.b.vpaid : !1,
            b = this.b.h,
            c = null != b ? this.b.h.fa() : this.J,
            b = null != b ? this.b.h.Na() : this.L;
        return {
            currentTime: c,
            duration: b,
            isVpaid: a,
            volume: this.V
        }
    };
    h.be = function() {
        sl(this, "skip")
    };
    h.start = function() {
        if (this.B && !O.ma()) {
            Fi() && !this.b.D && Kj(Hj.getInstance(), 26, {
                adtagurl: this.B,
                customPlayback: this.b.j()
            });
            Kf(this.b.g) && Kj(Hj.getInstance(), 30, {
                adtagurl: this.B,
                customPlayback: this.b.j()
            });
            var a = this.b.l,
                b = this.b.g,
                c;
            if (c = a && b && !Kf(a)) a = Ri(a), b = Ri(b), c = 0 < a.width && 0 < a.height && 0 < b.width && 0 < b.height && a.left <= b.left + b.width && b.left <= a.left + a.width && a.top <= b.top + b.height && b.top <= a.top + a.height;
            c && Kj(Hj.getInstance(), 31, {
                adtagurl: this.B,
                customPlayback: this.b.j()
            })
        }
        if (Fi() && !this.b.D && !this.b.j()) throw Tj(Rj);
        b = this.b;
        b.A = this.O && null != b.l;
        this.b.m.g.style.opacity = 1;
        sl(this, "start")
    };
    h.Be = function() {
        if ((null == this.j || !this.j.disableClickThrough) && null != this.g) {
            var a = this.g.ic();
            null != a && window.open(Fj(a), "_blank")
        }
    };
    h.kc = function(a, b, c) {
        var d = this.b,
            e = d.g;
        null != e && (-1 == a ? (e.style.right = 0, e.style.left = 0) : e.style.width = a + "px", -1 == b ? (e.style.bottom = 0, e.style.top = 0) : e.style.height = b + "px");
        null != d.m && (d = d.m, d.g.width = -1 == a ? "100%" : a, d.g.height = -1 == b ? "100%" : b);
        sl(this, "resize", {
            width: a,
            height: b,
            viewMode: c
        })
    };
    h.ce = function() {
        sl(this, "stop")
    };
    h.Qd = function() {
        sl(this, "expand")
    };
    h.Pd = function() {
        sl(this, "collapse")
    };
    h.Vd = function() {
        return this.V
    };
    h.ae = function(a) {
        this.V = a;
        var b = this.b.h;
        null != b && b.mb(a);
        sl(this, "volume", {
            volume: a
        })
    };
    h.$d = function(a) {
        sl(this, "mediaUrl", {
            mediaUrl: a
        })
    };
    h.Xd = function() {
        sl(this, "pause")
    };
    h.Yd = function() {
        sl(this, "resume")
    };
    h.jc = function() {
        this.M()
    };
    h.Sd = function() {
        return this.da
    };
    h.Td = function() {
        return this.g
    };
    h.H = function() {
        sl(this, "destroy");
        null != this.h && this.h.M();
        this.N.M();
        this.m.clear();
        this.o && (Re(this.o.b), this.o.M());
        Z.X.H.call(this)
    };
    var vl = function(a, b, c) {
        N.call(this, "adsManagerLoaded");
        this.g = a;
        this.h = b;
        this.m = c || ""
    };
    A(vl, N);
    vl.prototype.j = function(a, b) {
        var c = this.g;
        c.aa = a;
        null != b && (c.j = b);
        null != a.currentTime && (c.o = new Uj(a), c.o.C("currentTimeUpdate", c.zc, !1, c), c.o.start(), c.zc());
        var d = {};
        null != b && Qb(d, b);
        c.O && (O.Qa() ? d.useVideoAdUi = !1 : d.useClickElement = !1, d.disableClickThrough = !0);
        sl(c, "configure", {
            adsRenderingSettings: d
        });
        return this.g
    };
    vl.prototype.w = function() {
        return this.h
    };
    vl.prototype.l = function() {
        return this.m
    };
    (function() {
        if (!Gb(function(a) {
            return a.match(M().location.href)
        })) {
            var a = dd();
            if (null == qb(a, function(a) {
                return Gb(function(c) {
                    return c.match(a.src)
                })
            })) throw Error("IMA SDK is either not loaded from a google domain or is not a supported version.");
        }
    })();
    var wl = function(a) {
        S.call(this);
        this.b = a;
        this.h = new F;
        this.g = this.b.m;
        this.j = new W(this);
        if (this.g) {
            a = Pi();
            var b = dl(this.g);
            if (!a.h) {
                a.b = b || null;
                a.b && (a.l.C(a.b, "activityMonitor", a.o), Vi(a));
                if (!(l.ima && l.ima.video && l.ima.video.client && l.ima.video.client.tagged)) {
                    r("ima.video.client.sdkTag", !0, void 0);
                    var c = l.document,
                        b = c.createElement("script"),
                        d = c.location.protocol;
                    "http:" != d && "https:" != d && (d = "");
                    b.src = d + "//s0.2mdn.net/instream/video/client.js";
                    b.async = !0;
                    b.type = "text/javascript";
                    c = c.getElementsByTagName("script")[0];
                    c.parentNode.insertBefore(b, c)
                }
                a.h = !0
            }
            b = String(Math.floor(1E9 * Math.random()));
            Tb(a.g, b, this.b.F);
            this.l = b
        }
        var e;
        a: {
            try {
                e = window.top.location.href
            } catch (f) {
                e = 2;
                break a
            }
            e = null != e ? e == window.document.location.href ? 0 : 1 : 2
        }
        Mj.b = e
    };
    A(wl, S);
    h = wl.prototype;
    h.H = function() {
        this.j.M();
        var a = Pi();
        Wb(a.g, this.l);
        wl.X.H.call(this)
    };
    h.se = function() {
        this.M()
    };
    h.te = function(a, b) {
        a.adTagUrl && Kj(Hj.getInstance(), 8, {
            adtagurl: a.adTagUrl,
            customPlayback: this.b.j(),
            customClick: null != this.b.l,
            restrict: O.za()
        });
        var c;
        try {
            c = window.top.location.href
        } catch (d) {
            c = window.location.href
        }
        a.location = c;
        a.referrer = window.document.referrer;
        a.supportsYouTubeHosted = this.b.B();
        var e = a.adTagUrl,
            f = this.b.w;
        c = [];
        var g = "",
            k = "";
        if (null != f) {
            for (var g = f, k = [], m = 0; g && 25 > m; ++m) {
                var p;
                a: {
                    if (g && g.nodeName && g.parentElement) {
                        p = g.nodeName.toString().toLowerCase();
                        for (var t = g.parentElement.childNodes,
                            D = 0, q = 0; q < t.length; ++q) {
                            var fb = t[q];
                            if (fb.nodeName && fb.nodeName.toString().toLowerCase() == p) {
                                if (g == fb) {
                                    p = "." + D;
                                    break a
                                }++D
                            }
                        }
                    }
                    p = ""
                }
                k.push((g.nodeName && g.nodeName.toString().toLowerCase()) + "" + p);
                g = g.parentElement
            }
            g = k.join();
            if (f) {
                f = (f = f.ownerDocument) ? f.defaultView || f.parentWindow : null;
                k = [];
                if (f) try {
                    for (var u = f.parent, m = 0; u && u != f && 25 > m; ++m) {
                        var Q = u.frames;
                        for (p = 0; p < Q.length; ++p)
                            if (f == Q[p]) {
                                k.push(p);
                                break
                            }
                        f = u;
                        u = f.parent
                    }
                } catch (yl) {}
                k = k.join()
            } else k = ""
        }
        c.push(g, k);
        if (null != e) {
            for (u = 0; u < ud.length - 1; ++u) c.push(Bc(e,
                ud[u]) || "");
            e = Bc(e, "videoad_start_delay");
            u = "";
            e && (e = parseInt(e, 10), u = 0 > e ? "postroll" : 0 == e ? "preroll" : "midroll");
            c.push(u)
        } else
            for (e = 0; e < ud.length; ++e) c.push("");
        c = c.join(":");
        e = c.length;
        if (0 == e) c = 0;
        else {
            u = 305419896;
            for (Q = 0; Q < e; Q++) u ^= (u << 5) + (u >> 2) + c.charCodeAt(Q) & 4294967295;
            c = 0 < u ? u : 4294967296 + u
        }
        a.videoAdKey = c.toString();
        c = a.adTagUrl;
        null != c && "ca-pub-6219811747049371" != Bc(c, "client") ? c = null : (c = aa("window.yt.util.activity.getTimeSinceActive"), c = null != c ? c().toString() : null);
        null != c && (a.lastActivity =
            c);
        c = a.adTagUrl;
        null != c ? (e = new Cc(c), c = e.w, e = e.b, u = e.length - 27, c = 0 <= u && e.indexOf("googleads.g.doubleclick.net", u) == u && (ka(va(c)) ? !1 : /\/pagead\/ads/.test(c))) : c = !1;
        if (c) {
            e = window;
            u = Qa().document;
            c = {};
            Q = eb(window).Za;
            (f = sd()) ? f = {
                url: f,
                pb: !0
            } : (f = Q.location.href, Q == Q.top ? f = {
                url: f,
                pb: !0
            } : (g = !1, (k = Q.document) && k.referrer && (f = k.referrer, Q.parent == Q.top && (g = !0)), (k = Q.location.ancestorOrigins) && (k = k[k.length - 1]) && -1 == f.indexOf(k) && (g = !1, f = k), f = {
                url: f,
                pb: g
            }));
            a: if (g = Qa(), k = e.ld || g.ld, m = e.kd || g.kd, g.top == g) g = !1;
            else {
                p = u.documentElement;
                if (k && m && (D = t = 1, g.innerHeight ? (t = g.innerWidth, D = g.innerHeight) : p && p.clientHeight ? (t = p.clientWidth, D = p.clientHeight) : u.body && (t = u.body.clientWidth, D = u.body.clientHeight), D > 2 * m || t > 2 * k)) {
                    g = !1;
                    break a
                }
                g = !0
            }
            f = f.pb;
            k = Qa();
            k = k.top == k ? 0 : Da(k.top) ? 1 : 2;
            m = 4;
            g || 1 != k ? g || 2 != k ? g && 1 == k ? m = 7 : g && 2 == k && (m = 8) : m = 6 : m = 5;
            f && (m |= 16);
            c.iframing = "" + m;
            if (!e.jb && "ad.yieldmanager.com" == u.domain) {
                for (f = u.URL.substring(u.URL.lastIndexOf("http")); - 1 < f.indexOf("%");) try {
                    f = decodeURIComponent(f)
                } catch (zl) {
                    break
                }
                e.jb =
                    f
            }!sd() && e.jb ? (c.page_url = e.jb, c.page_location = td(u, g) || "EMPTY") : (c.page_url = td(u, g), c.page_location = null);
            c.last_modified_time = u.URL == c.page_url ? Date.parse(u.lastModified) / 1E3 : null;
            c.referrer_url = Q == Q.top ? Q.document.referrer : sd(!0) || "";
            "4087311" == Va(35) && c.referrer_url && 0 <= tc(c.referrer_url).indexOf("google.com") && -1 == c.referrer_url.indexOf("q=") && (e = u.getElementsByTagName("title"), 0 < e.length && (e = e[0], $c && "innerText" in e ? e = e.innerText.replace(/(\r\n|\r|\n)/g, "\n") : (u = [], qd(e, u, !0), e = u.join("")),
                e = e.replace(/ \xAD /g, " ").replace(/\xAD/g, ""), e = e.replace(/\u200B/g, ""), $c || (e = e.replace(/ +/g, " ")), " " != e && (e = e.replace(/^\s*/, "")), c.referrer_url = "https://www.google.com/?q=" + e));
            a.adSenseParams = c
        }
        e = "goog_" + ya++;
        Tb(this.h, e, b || null);
        c = {};
        Qb(c, a);
        u = this.Z().qc();
        Q = this.Z().lc();
        f = this.Z().ma();
        g = this.Z().ob();
        k = this.Z().Qa();
        m = this.Z().mc();
        p = this.Z().nc();
        var t = this.Z().oc(),
            D = this.Z().pc(),
            q = this.Z().za(),
            fb = this.Z().Me(),
            tl = this.Z().h,
            ul = Bd(this.Z());
        c.settings = {
            autoPlayAdBreaks: u,
            chromelessPlayer: !0,
            companionBackfill: Q,
            engagementDetection: !0,
            isAdMob: f,
            isFunctionalTest: g,
            isYouTube: k,
            numRedirects: m,
            onScreenDetection: !0,
            playerType: p,
            playerVersion: t,
            ppid: D,
            restrictToCustomPlayback: q,
            useCompanionsAsEndSlate: fb,
            vpaidMode: tl,
            testingConfig: ul.b
        };
        u = this.b.h;
        c.videoEnvironment = {
            iframeState: Mj.b,
            osdId: this.l,
            supportedMimeTypes: null != u ? u.ec() : null,
            usesChromelessPlayer: this.b.J(),
            usesCustomVideoPlayback: this.b.j(),
            usesYouTubePlayer: this.b.B()
        };
        e = dl(this.g, e);
        this.j.C(e, "adsLoader", this.md);
        e.send("adsLoader",
            "requestAds", c)
    };
    h.Z = function() {
        return O
    };
    h.re = function() {
        dl(this.g).send("adsLoader", "contentComplete")
    };
    h.md = function(a) {
        switch (a.U) {
            case "adsLoaded":
                var b = a.P;
                a = a.Ma;
                var c = new Z(this.b, b.adTagUrl || "", b.adCuePoints, b.isCustomClickTrackingAllowed, dl(this.g, a));
                this.dispatchEvent(new vl(c, this.h.get(a), b.response));
                break;
            case "error":
                b = a.P, a = a.Ma, c = new vd(b.type, b.errorMessage, b.errorCode), null != b.innerError && (c.g = Error(b.innerError)), this.dispatchEvent(new zd(c, this.h.get(a))), Kj(Hj.getInstance(), 7, {
                    error: b.errorCode
                }, !0)
        }
    };
    var xl = function() {};
    h = xl.prototype;
    h.clone = function() {
        var a = new xl;
        "auto" == this.videoPlayActivation ? a.videoPlayActivation = "auto" : "click" == this.videoPlayActivation && (a.videoPlayActivation = "click");
        a.adTagUrl = this.adTagUrl;
        a.adSenseParams = Ob(this.adSenseParams);
        a.adsResponse = this.adsResponse;
        a.customMacros = Ob(this.customMacros);
        a.g = this.g;
        a.location = this.location;
        a.referrer = this.referrer;
        a.lastActivity = this.lastActivity;
        a.language = this.language;
        a.linearAdSlotWidth = this.linearAdSlotWidth;
        a.linearAdSlotHeight = this.linearAdSlotHeight;
        a.nonLinearAdSlotWidth =
            this.nonLinearAdSlotWidth;
        a.nonLinearAdSlotHeight = this.nonLinearAdSlotHeight;
        a.videoAdKey = this.videoAdKey;
        a.tagForChildDirectedContent = this.tagForChildDirectedContent;
        a.usePostAdRequests = this.usePostAdRequests;
        a.supportsYouTubeHosted = this.supportsYouTubeHosted;
        a.youTubeAdType = this.youTubeAdType;
        a.youTubeExperimentIds = this.youTubeExperimentIds;
        a.youTubeVideoAdStartTime = this.youTubeVideoAdStartTime;
        a.bc = this.bc;
        a.ac = this.ac;
        this.b && (a.b = vb(this.b));
        return a
    };
    h.adSenseParams = null;
    h.customMacros = null;
    h.videoPlayActivation = "unknown";
    h.linearAdSlotWidth = 0;
    h.linearAdSlotHeight = 0;
    h.nonLinearAdSlotWidth = 0;
    h.nonLinearAdSlotHeight = 0;
    h.videoAdKey = null;
    h.tagForChildDirectedContent = !1;
    h.usePostAdRequests = !1;
    h.supportsYouTubeHosted = !0;
    h.youTubeVideoAdStartTime = 0;
    h.bc = null;
    h.ac = !1;
    Y.prototype.getClickThroughUrl = Y.prototype.ic;
    Y.prototype.getCompanionAds = Y.prototype.Dd;
    Y.prototype.isLinear = Y.prototype.Nd;
    Y.prototype.isSkippable = Y.prototype.Od;
    Y.prototype.getAdId = Y.prototype.zd;
    Y.prototype.getAdSystem = Y.prototype.Cd;
    Y.prototype.getContentType = Y.prototype.Ed;
    Y.prototype.getDescription = Y.prototype.fd;
    Y.prototype.getTitle = Y.prototype.gd;
    Y.prototype.getDuration = Y.prototype.lb;
    Y.prototype.getHeight = Y.prototype.Fd;
    Y.prototype.getWidth = Y.prototype.Kd;
    Y.prototype.getWrapperAdIds = Y.prototype.Ld;
    Y.prototype.getWrapperAdSystems = Y.prototype.Md;
    Y.prototype.getTraffickingParameters = Y.prototype.Hd;
    Y.prototype.getTraffickingParametersString = Y.prototype.Id;
    Y.prototype.getAdPodInfo = Y.prototype.Bd;
    Y.prototype.getUiElements = Y.prototype.Jd;
    Y.prototype.getMinSuggestedDuration = Y.prototype.Gd;
    Nj.prototype.getCuePoints = Nj.prototype.b;
    r("google.ima.AdCuePoints.PREROLL", 0, window);
    r("google.ima.AdCuePoints.POSTROLL", -1, window);
    r("google.ima.AdDisplayContainer", hl, window);
    hl.prototype.initialize = hl.prototype.I;
    hl.prototype.destroy = hl.prototype.G;
    ok.prototype.getPodIndex = ok.prototype.wd;
    ok.prototype.getTimeOffset = ok.prototype.xd;
    ok.prototype.getTotalAds = ok.prototype.yd;
    ok.prototype.getMaxDuration = ok.prototype.vd;
    ok.prototype.getAdPosition = ok.prototype.sd;
    ok.prototype.getIsBumper = ok.prototype.ud;
    r("google.ima.AdError.ErrorCode.VIDEO_PLAY_ERROR", 400, window);
    r("google.ima.AdError.ErrorCode.FAILED_TO_REQUEST_ADS", 1005, window);
    r("google.ima.AdError.ErrorCode.REQUIRED_LISTENERS_NOT_ADDED", 900, window);
    r("google.ima.AdError.ErrorCode.VAST_LOAD_TIMEOUT", 301, window);
    r("google.ima.AdError.ErrorCode.VAST_NO_ADS_AFTER_WRAPPER", 303, window);
    r("google.ima.AdError.ErrorCode.VAST_MEDIA_LOAD_TIMEOUT", 402, window);
    r("google.ima.AdError.ErrorCode.VAST_TOO_MANY_REDIRECTS", 302, window);
    r("google.ima.AdError.ErrorCode.VAST_ASSET_MISMATCH", 403, window);
    r("google.ima.AdError.ErrorCode.VAST_LINEAR_ASSET_MISMATCH", 403, window);
    r("google.ima.AdError.ErrorCode.VAST_NONLINEAR_ASSET_MISMATCH", 503, window);
    r("google.ima.AdError.ErrorCode.VAST_ASSET_NOT_FOUND", 1007, window);
    r("google.ima.AdError.ErrorCode.VAST_UNSUPPORTED_VERSION", 102, window);
    r("google.ima.AdError.ErrorCode.VAST_SCHEMA_VALIDATION_ERROR", 101, window);
    r("google.ima.AdError.ErrorCode.VAST_TRAFFICKING_ERROR", 200, window);
    r("google.ima.AdError.ErrorCode.VAST_UNEXPECTED_LINEARITY", 201, window);
    r("google.ima.AdError.ErrorCode.INVALID_ARGUMENTS", 1101, window);
    r("google.ima.AdError.ErrorCode.UNKNOWN_AD_RESPONSE", 1010, window);
    r("google.ima.AdError.ErrorCode.UNKNOWN_ERROR", 900, window);
    r("google.ima.AdError.ErrorCode.OVERLAY_AD_PLAYING_FAILED", 500, window);
    r("google.ima.AdError.ErrorCode.VIDEO_ELEMENT_USED", -1, window);
    r("google.ima.AdError.ErrorCode.VIDEO_ELEMENT_REQUIRED", -1, window);
    r("google.ima.AdError.ErrorCode.VAST_MEDIA_ERROR", -1, window);
    r("google.ima.AdError.ErrorCode.ADSLOT_NOT_VISIBLE", -1, window);
    r("google.ima.AdError.ErrorCode.OVERLAY_AD_LOADING_FAILED", -1, window);
    r("google.ima.AdError.ErrorCode.VAST_MALFORMED_RESPONSE", -1, window);
    r("google.ima.AdError.ErrorCode.COMPANION_AD_LOADING_FAILED", -1, window);
    r("google.ima.AdError.Type.AD_LOAD", "adLoadError", window);
    r("google.ima.AdError.Type.AD_PLAY", "adPlayError", window);
    vd.prototype.getErrorCode = vd.prototype.gc;
    vd.prototype.getVastErrorCode = vd.prototype.hd;
    vd.prototype.getInnerError = vd.prototype.kb;
    vd.prototype.getMessage = vd.prototype.hc;
    vd.prototype.getType = vd.prototype.rd;
    r("google.ima.AdErrorEvent.Type.AD_ERROR", "adError", window);
    zd.prototype.getError = zd.prototype.j;
    zd.prototype.getUserRequestContext = zd.prototype.l;
    r("google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED", "contentResumeRequested", window);
    r("google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED", "contentPauseRequested", window);
    r("google.ima.AdEvent.Type.CLICK", "click", window);
    r("google.ima.AdEvent.Type.EXPANDED_CHANGED", "expandedChanged", window);
    r("google.ima.AdEvent.Type.STARTED", "start", window);
    r("google.ima.AdEvent.Type.IMPRESSION", "impression", window);
    r("google.ima.AdEvent.Type.PAUSED", "pause", window);
    r("google.ima.AdEvent.Type.RESUMED", "resume", window);
    r("google.ima.AdEvent.Type.FIRST_QUARTILE", "firstquartile", window);
    r("google.ima.AdEvent.Type.MIDPOINT", "midpoint", window);
    r("google.ima.AdEvent.Type.THIRD_QUARTILE", "thirdquartile", window);
    r("google.ima.AdEvent.Type.COMPLETE", "complete", window);
    r("google.ima.AdEvent.Type.USER_CLOSE", "userClose", window);
    r("google.ima.AdEvent.Type.LOADED", "loaded", window);
    r("google.ima.AdEvent.Type.AD_METADATA", "adMetadata", window);
    r("google.ima.AdEvent.Type.AD_BREAK_READY", "adBreakReady", window);
    r("google.ima.AdEvent.Type.ALL_ADS_COMPLETED", "allAdsCompleted", window);
    r("google.ima.AdEvent.Type.SKIPPED", "skip", window);
    r("google.ima.AdEvent.Type.SKIPPABLE_STATE_CHANGED", "skippableStateChanged", window);
    r("google.ima.AdEvent.Type.LOG", "log", window);
    r("google.ima.AdEvent.Type.VOLUME_CHANGED", "volumeChange", window);
    r("google.ima.AdEvent.Type.VOLUME_MUTED", "mute", window);
    V.prototype.type = V.prototype.type;
    V.prototype.getAd = V.prototype.w;
    V.prototype.getAdData = V.prototype.m;
    Vj.prototype.getAdCuePoints = Vj.prototype.l;
    r("google.ima.AdsLoader", wl, window);
    wl.prototype.getSettings = wl.prototype.Z;
    wl.prototype.requestAds = wl.prototype.te;
    wl.prototype.contentComplete = wl.prototype.re;
    wl.prototype.destroy = wl.prototype.se;
    r("google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED", "adsManagerLoaded", window);
    vl.prototype.getAdsManager = vl.prototype.j;
    vl.prototype.getUserRequestContext = vl.prototype.w;
    vl.prototype.getResponse = vl.prototype.l;
    r("google.ima.CompanionAdSelectionSettings", ek, window);
    r("google.ima.CompanionAdSelectionSettings.CreativeType.IMAGE", "Image", void 0);
    r("google.ima.CompanionAdSelectionSettings.CreativeType.FLASH", "Flash", void 0);
    r("google.ima.CompanionAdSelectionSettings.CreativeType.ALL", "All", void 0);
    r("google.ima.CompanionAdSelectionSettings.ResourceType.HTML", "Html", void 0);
    r("google.ima.CompanionAdSelectionSettings.ResourceType.IFRAME", "IFrame", void 0);
    r("google.ima.CompanionAdSelectionSettings.ResourceType.STATIC", "Static", void 0);
    r("google.ima.CompanionAdSelectionSettings.ResourceType.ALL", "All", void 0);
    r("google.ima.CompanionAdSelectionSettings.SizeCriteria.IGNORE", "IgnoreSize", void 0);
    r("google.ima.CompanionAdSelectionSettings.SizeCriteria.SELECT_EXACT_MATCH", "SelectExactMatch", void 0);
    r("google.ima.CompanionAdSelectionSettings.SizeCriteria.SELECT_NEAR_MATCH", "SelectNearMatch", void 0);
    r("google.ima.CustomContentLoadedEvent.Type.CUSTOM_CONTENT_LOADED", "deprecated-event", window);
    r("ima.ImaSdkSettings", P, window);
    r("google.ima.settings", O, window);
    P.prototype.setCompanionBackfill = P.prototype.ee;
    P.prototype.getCompanionBackfill = P.prototype.lc;
    P.prototype.setAutoPlayAdBreaks = P.prototype.de;
    P.prototype.isAutoPlayAdBreak = P.prototype.qc;
    P.prototype.setPpid = P.prototype.ie;
    P.prototype.getPpid = P.prototype.pc;
    P.prototype.setVpaidAllowed = P.prototype.ke;
    P.prototype.setVpaidMode = P.prototype.ne;
    P.prototype.setRestrictToCustomPlayback = P.prototype.je;
    P.prototype.isRestrictToCustomPlayback = P.prototype.za;
    P.prototype.setNumRedirects = P.prototype.fe;
    P.prototype.getNumRedirects = P.prototype.mc;
    P.prototype.getLocale = P.prototype.hb;
    P.prototype.setLocale = P.prototype.Le;
    P.prototype.getPlayerType = P.prototype.nc;
    P.prototype.setPlayerType = P.prototype.ge;
    P.prototype.getPlayerVersion = P.prototype.oc;
    P.prototype.setPlayerVersion = P.prototype.he;
    r("google.ima.ImaSdkSettings.CompanionBackfillMode.ALWAYS", "always", void 0);
    r("google.ima.ImaSdkSettings.CompanionBackfillMode.ON_MASTER_AD", "on_master_ad", void 0);
    r("google.ima.ImaSdkSettings.VpaidMode.DISABLED", 0, void 0);
    r("google.ima.ImaSdkSettings.VpaidMode.ENABLED", 1, void 0);
    r("google.ima.ImaSdkSettings.VpaidMode.INSECURE", 2, void 0);
    r("google.ima.AdsRenderingSettings", qk, window);
    r("google.ima.AdsRenderingSettings.AUTO_SCALE", -1, window);
    r("google.ima.AdsRequest", xl, window);
    xl.prototype.adTagUrl = xl.prototype.adTagUrl;
    xl.prototype.adsResponse = xl.prototype.adsResponse;
    xl.prototype.nonLinearAdSlotHeight = xl.prototype.nonLinearAdSlotHeight;
    xl.prototype.nonLinearAdSlotWidth = xl.prototype.nonLinearAdSlotWidth;
    xl.prototype.linearAdSlotHeight = xl.prototype.linearAdSlotHeight;
    xl.prototype.linearAdSlotWidth = xl.prototype.linearAdSlotWidth;
    r("google.ima.VERSION", "3.101.4", void 0);
    r("google.ima.UiElements.AD_ATTRIBUTION", "adAttribution", void 0);
    r("google.ima.UiElements.COUNTDOWN", "countdown", void 0);
    r("google.ima.ViewMode.NORMAL", "normal", void 0);
    r("google.ima.ViewMode.FULLSCREEN", "fullscreen", void 0);
    Z.prototype.isCustomPlaybackUsed = Z.prototype.ve;
    Z.prototype.isCustomClickTrackingUsed = Z.prototype.ue;
    Z.prototype.destroy = Z.prototype.jc;
    Z.prototype.init = Z.prototype.Wd;
    Z.prototype.start = Z.prototype.start;
    Z.prototype.stop = Z.prototype.ce;
    Z.prototype.pause = Z.prototype.Xd;
    Z.prototype.resume = Z.prototype.Yd;
    Z.prototype.getCuePoints = Z.prototype.Sd;
    Z.prototype.getCurrentAd = Z.prototype.Td;
    Z.prototype.getRemainingTime = Z.prototype.Ud;
    Z.prototype.expand = Z.prototype.Qd;
    Z.prototype.collapse = Z.prototype.Pd;
    Z.prototype.getAdSkippableState = Z.prototype.Rd;
    Z.prototype.resize = Z.prototype.kc;
    Z.prototype.skip = Z.prototype.be;
    Z.prototype.getVolume = Z.prototype.Vd;
    Z.prototype.setVolume = Z.prototype.ae;
    Z.prototype.setMediaUrl = Z.prototype.$d;
    Z.prototype.sendImpressionUrls = Z.prototype.Zd;
    pk.prototype.getContent = pk.prototype.getContent;
    pk.prototype.getContentType = pk.prototype.g;
    pk.prototype.getHeight = pk.prototype.o;
    pk.prototype.getWidth = pk.prototype.D;
})();