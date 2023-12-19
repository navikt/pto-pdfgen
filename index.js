

module.exports = jsonHelper;

function jsonHelper(props) {
    const obj = props.json ? (typeof props.json === 'string' ? JSON.parse(props.json) : props.json) : null;

    return <div className={props.className}>{objToReact(obj)}</div>;
}

function objToReact(obj) {
    if (obj == null || typeof obj !== 'object') {
        return <p>Ingen data</p>;
    }

    return (
        <>
            {Object.entries(obj).map(([key, value], idx) => {
                if (isType(value, 'string', 'boolean', 'number')) {
                    const element = isType(value, 'string') && checkIfLink(value, key, idx);
                    return element ? (
                        element
                    ) : (
                        <div key={idx} className="json-key-wrapper">
                            <span className="json-key">{prettifyKey(key)}: </span>
                            <span>{scalarToString(value)}</span>
                        </div>
                    );
                } else if (Array.isArray(value)) {
                    return (
                        <div key={idx} className="json-array-wrapper">
                            <JsonKey keyText={key} />
                            {value.length > 0 ? (
                                <ul className="json-array">
                                    {value.map((arrVal, index) => (
                                        <li key={index}>{objToReact(arrVal)}</li>
                                    ))}
                                </ul>
                            ) : (
                                <p className="json-array-empty">Ingen oppføringer</p>
                            )}
                        </div>
                    );
                } else if (isType(value, 'object')) {
                    return (
                        <div key={key}>
                            <JsonKey keyText={key} />
                            <div className="json-obj">{objToReact(value)}</div>
                        </div>
                    );
                }

                return null;
            })}
        </>
    );
}
function checkIfLink(value, key, idx) {
    if (!key.includes('lenke')) {
        return;
    }

    return (
        <div key={idx} className="json-key-wrapper">
            <span className="json-key">{prettifyKey(key)}: </span>
            <Link href={value} target="_blank" rel="noopener noreferrer">
                {value}
            </Link>
        </div>
    );
}

function JsonKey({ keyText }) {
    return <h3 className="json-key">{prettifyKey(keyText)}</h3>;
}

function scalarToString(scalar) {
    if (isType(scalar, 'boolean')) {
        return scalar ? 'Ja' : 'Nei';
    }

    return scalar.toString();
}

function prettifyKey(key) {
    let str = key.replace(/([A-Z])/g, ' $1').toLowerCase();

    if (str.charAt(0) === str.charAt(0).toLowerCase()) {
        str = str.charAt(0).toUpperCase() + str.substr(1);
    }

    return str;
}