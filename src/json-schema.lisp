(defpackage json-schema
  (:use :cl :alexandria)
  (:shadowing-import-from :json-schema.validators
                          :schema-version)
  (:export #:validate
           #:*schema-version*
           #:schema-version))

(in-package :json-schema)


(defparameter *schema-version* :draft7)


(defun validate (schema data &key (schema-version *schema-version*) (pretty-errors-p t))
  "The primary validation function for json-schema.  Takes a schema of type hash-table, data: which can be a simple value or an object as a hash table, and then optionall accepts a schema version and pretty-errors-p deterimines whether the second return value is exception objects or strings of the rendered errors (strings by default)."

  (json-schema.reference:with-context ((json-schema.reference:get-id-fun-for-draft schema-version))
    (json-schema.reference:with-pushed-context (schema)
      (if-let ((errors (json-schema.validators:validate schema data schema-version)))
        (values nil (mapcar (if pretty-errors-p #'princ-to-string #'identity) errors))
        (values t nil)))))
