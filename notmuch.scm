(foreign-declare "#include <time.h>")
(foreign-declare "#include <notmuch.h>")

(module
 notmuch *

 (import scheme chicken foreign)

 (define NOTMUCH-TAG-MAX (foreign-value "NOTMUCH_TAG_MAX" int))
 (define notmuch-version (list (foreign-value "LIBNOTMUCH_MAJOR_VERSION" int)
                               (foreign-value "LIBNOTMUCH_MINOR_VERSION" int)
                               (foreign-value "LIBNOTMUCH_MICRO_VERSION" int)))

 (define-foreign-type time_t unsigned-long)

 (define-foreign-type notmuch-status int)
 (define notmuch-status/success (foreign-value "NOTMUCH_STATUS_SUCCESS" int))
 (define notmuch-status/out-of-memory (foreign-value "NOTMUCH_STATUS_OUT_OF_MEMORY" int))
 (define notmuch-status/read-only-database (foreign-value "NOTMUCH_STATUS_READ_ONLY_DATABASE" int))
 (define notmuch-status/xapian-exception (foreign-value "NOTMUCH_STATUS_XAPIAN_EXCEPTION" int))
 (define notmuch-status/file-error (foreign-value "NOTMUCH_STATUS_FILE_ERROR" int))
 (define notmuch-status/file-not-email (foreign-value "NOTMUCH_STATUS_FILE_NOT_EMAIL" int))
 (define notmuch-status/duplicate-message-id (foreign-value "NOTMUCH_STATUS_DUPLICATE_MESSAGE_ID" int))
 (define notmuch-status/null-pointer (foreign-value "NOTMUCH_STATUS_NULL_POINTER" int))
 (define notmuch-status/tag-too-long (foreign-value "NOTMUCH_STATUS_TAG_TOO_LONG" int))
 (define notmuch-status/unbalanced-freeze-thaw (foreign-value "NOTMUCH_STATUS_UNBALANCED_FREEZE_THAW" int))
 (define notmuch-status/unbalanced-atomic (foreign-value "NOTMUCH_STATUS_UNBALANCED_ATOMIC" int))
 (define notmuch-status/unsupported-operation (foreign-value "NOTMUCH_STATUS_UNSUPPORTED_OPERATION" int))

 (define-foreign-type notmuch-database-mode int)
 (define notmuch-database-mode/read-only (foreign-value "NOTMUCH_DATABASE_MODE_READ_ONLY" int))
 (define notmuch-database-mode/read-write (foreign-value "NOTMUCH_DATABASE_MODE_READ_WRITE" int))

 (define-foreign-type notmuch-sort int)
 (define notmuch-sort/oldest_first (foreign-value "NOTMUCH_SORT_OLDEST_FIRST" int))
 (define notmuch-sort/newest_first (foreign-value "NOTMUCH_SORT_NEWEST_FIRST" int))
 (define notmuch-sort/message_id (foreign-value "NOTMUCH_SORT_MESSAGE_ID" int))
 (define notmuch-sort/unsorted (foreign-value "NOTMUCH_SORT_UNSORTED" int))

 (define-foreign-type notmuch-exclude int)
 (define notmuch-exclude/flag (foreign-value "NOTMUCH_EXCLUDE_FLAG" int))
 (define notmuch-exclude/true (foreign-value "NOTMUCH_EXCLUDE_TRUE" int))
 (define notmuch-exclude/false (foreign-value "NOTMUCH_EXCLUDE_FALSE" int))
 (define notmuch-exclude/all (foreign-value "NOTMUCH_EXCLUDE_ALL" int))

 (define-foreign-type notmuch-message-flag int)
 (define notmuch-message-flag/match (foreign-value "NOTMUCH_MESSAGE_FLAG_MATCH" int))
 (define notmuch-message-flag/excluded (foreign-value "NOTMUCH_MESSAGE_FLAG_EXCLUDED" int))

 (define notmuch-status->string
   (foreign-lambda c-string "notmuch_status_to_string" notmuch-status))

 (define-foreign-type notmuch-database (c-pointer "notmuch_database_t"))
 (define-foreign-type notmuch-query (c-pointer "notmuch_query_t"))
 (define-foreign-type notmuch-threads (c-pointer "notmuch_threads_t"))
 (define-foreign-type notmuch-thread (c-pointer "notmuch_thread_t"))
 (define-foreign-type notmuch-messages (c-pointer "notmuch_messages_t"))
 (define-foreign-type notmuch-message (c-pointer "notmuch_message_t"))
 (define-foreign-type notmuch-tags (c-pointer "notmuch_tags_t"))
 (define-foreign-type notmuch-directory (c-pointer "notmuch_directory_t"))
 (define-foreign-type notmuch-filenames (c-pointer "notmuch_filenames_t"))

 (define notmuch-database-create
   (foreign-lambda notmuch-status "notmuch_database_create" c-string (c-pointer notmuch-database)))

 (define notmuch-database-open
   (foreign-lambda notmuch-status "notmuch_database_open" c-string int (c-pointer notmuch-database)))

 (define notmuch-database-close
   (foreign-lambda void "notmuch_database_close" notmuch-database))

 (define notmuch-database-compact
   (foreign-lambda notmuch-status "notmuch_database_compact" c-string c-string c-pointer c-pointer))

 (define notmuch-database-destroy
   (foreign-lambda void "notmuch_database_destroy" notmuch-database))

 (define notmuch-database-get-path
   (foreign-lambda c-string "notmuch_database_get_path" notmuch-database))

 (define notmuch-database-get-version
   (foreign-lambda unsigned-int "notmuch_database_get_version" notmuch-database))

 (define notmuch-database-needs-upgrade
   (foreign-lambda bool "notmuch_database_needs_upgrade" notmuch-database))

 (define notmuch-database-upgrade
   (foreign-lambda notmuch-status "notmuch_database_upgrade" notmuch-database c-pointer c-pointer))

 (define notmuch-database-begin-atomic
   (foreign-lambda notmuch-status "notmuch_database_begin_atomic" notmuch-database))

 (define notmuch-database-end-atomic
   (foreign-lambda notmuch-status "notmuch_database_end_atomic" notmuch-database))

 (define notmuch-database-get-directory
   (foreign-lambda notmuch-status "notmuch_database_get_directory" notmuch-database c-string (c-pointer notmuch-directory)))

 (define notmuch-database-add-message
   (foreign-lambda notmuch-status "notmuch_database_add_message" notmuch-database c-string (c-pointer notmuch-message)))

 (define notmuch-database-remove-message
   (foreign-lambda notmuch-status "notmuch_database_remove_message" notmuch-database c-string))

 (define notmuch-database-find-message
   (foreign-lambda notmuch-status "notmuch_database_find_message" notmuch-database c-string (c-pointer notmuch-message)))

 (define notmuch-database-find-message-by-filename
   (foreign-lambda notmuch-status "notmuch_database_find_message_by_filename" notmuch-database c-string (c-pointer notmuch-message)))

 (define notmuch-database-get-all-tags
   (foreign-lambda notmuch-tags "notmuch_database_get_all_tags" notmuch-database))

 (define notmuch-query-create
   (foreign-lambda notmuch-query "notmuch_query_create" notmuch-database c-string))

 (define notmuch-query-get-query-string
   (foreign-lambda c-string "notmuch_query_get_query_string" notmuch-query))

 (define notmuch-query-set-omit-excluded
   (foreign-lambda void "notmuch_query_set_omit_excluded" notmuch-query notmuch-exclude))

 (define notmuch-query-set-sort
   (foreign-lambda void "notmuch_query_set_sort" notmuch-query notmuch-sort))

 (define notmuch-query-get-sort
   (foreign-lambda notmuch-sort "notmuch_query_get_sort" notmuch-query))

 (define notmuch-query-add-tag-exclude
   (foreign-lambda void "notmuch_query_add_tag_exclude" notmuch-query c-string))

 (define notmuch-query-search-threads
   (foreign-lambda unsigned-int "notmuch_query_search_threads" notmuch-query (c-pointer notmuch-threads)))

 (define notmuch-query-search-messages
   (foreign-lambda unsigned-int "notmuch_query_search_messages" notmuch-query (c-pointer notmuch-messages)))

 (define notmuch-query-destroy
   (foreign-lambda void "notmuch_query_destroy" notmuch-query))

 (define notmuch-threads-valid
   (foreign-lambda bool "notmuch_threads_valid" notmuch-threads))

 (define notmuch-threads-get
   (foreign-lambda notmuch-thread "notmuch_threads_get" notmuch-threads))

 (define notmuch-threads-move-to-next
   (foreign-lambda void "notmuch_threads_move_to_next" notmuch-threads))

 (define notmuch-threads-destroy
   (foreign-lambda void "notmuch_threads_destroy" notmuch-threads))

 (define %notmuch-query-count-messages
   (foreign-lambda unsigned-int "notmuch_query_count_messages" notmuch-query (c-pointer unsigned-int)))

 (define (notmuch-query-count-messages query)
   (let-location
       ([count unsigned-int])
     (let ((status (%notmuch-query-count-messages query #$count)))
       count)))

 (define notmuch-query-count-threads
   (foreign-lambda unsigned-int "notmuch_query_count_threads" notmuch-query (c-pointer unsigned-int)))

 (define notmuch-thread-get-thread-id
   (foreign-lambda c-string "notmuch_thread_get_thread_id" notmuch-thread))

 (define notmuch-thread-get-total-messages
   (foreign-lambda int "notmuch_thread_get_total_messages" notmuch-thread))

 (define notmuch-thread-get-toplevel-messages
   (foreign-lambda notmuch-messages "notmuch_thread_get_toplevel_messages" notmuch-thread))

 (define notmuch-thread-get-messages
   (foreign-lambda notmuch-messages "notmuch_thread_get_messages"  notmuch-thread))

 (define notmuch-thread-get-matched-messages
   (foreign-lambda int "notmuch_thread_get_matched_messages" notmuch-thread))

 (define notmuch-thread-get-authors
   (foreign-lambda c-string "notmuch_thread_get_authors" notmuch-thread))

 (define notmuch-thread-get-subject
   (foreign-lambda c-string "notmuch_thread_get_subject" notmuch-thread))

 (define notmuch-thread-get-oldest-date
   (foreign-lambda time_t "notmuch_thread_get_oldest_date" notmuch-thread))

 (define notmuch-thread-get-newest-date
   (foreign-lambda time_t "notmuch_thread_get_newest_date" notmuch-thread))

 (define notmuch-thread-get-tags
   (foreign-lambda notmuch-tags "notmuch_thread_get_tags" notmuch-thread))

 (define notmuch-thread-destroy
   (foreign-lambda void "notmuch_thread_destroy" notmuch-thread))

 (define notmuch-messages-valid
   (foreign-lambda bool "notmuch_messages_valid" notmuch-messages))

 (define notmuch-messages-get
   (foreign-lambda notmuch-message  "notmuch_messages_get" notmuch-messages))

 (define notmuch-messages-move-to-next
   (foreign-lambda void "notmuch_messages_move_to_next" notmuch-messages))

 (define notmuch-messages-destroy
   (foreign-lambda void "notmuch_messages_destroy" notmuch-messages))

 (define notmuch-messages-collect-tags
   (foreign-lambda notmuch-tags "notmuch_messages_collect_tags" notmuch-messages))

 (define notmuch-message-get-message-id
   (foreign-lambda c-string "notmuch_message_get_message_id" notmuch-message))

 (define notmuch-message-get-thread-id
   (foreign-lambda c-string "notmuch_message_get_thread_id" notmuch-message))

 (define notmuch-message-get-replies
   (foreign-lambda notmuch-messages "notmuch_message_get_replies" notmuch-message))

 (define notmuch-message-get-filename
   (foreign-lambda c-string "notmuch_message_get_filename" notmuch-message))

 (define notmuch-message-get-filenames
   (foreign-lambda notmuch-filenames "notmuch_message_get_filenames" notmuch-message))

 (define notmuch-message-get-flag
   (foreign-lambda bool "notmuch_message_get_flag" notmuch-message notmuch-message-flag))

 (define notmuch-message-set-flag
   (foreign-lambda void "notmuch_message_set_flag" notmuch-message notmuch-message-flag bool))

 (define notmuch-message-get-date
   (foreign-lambda time_t "notmuch_message_get_date " notmuch-message))

 (define notmuch-message-get-header
   (foreign-lambda c-string "notmuch_message_get_header" notmuch-message c-string))

 (define notmuch-message-get-tags
   (foreign-lambda notmuch-tags  "notmuch_message_get_tags" notmuch-message))

 (define notmuch-message-maildir-flags-to-tags
   (foreign-lambda notmuch-status "notmuch_message_maildir_flags_to_tags" notmuch-message))

 (define notmuch-message-tags-to-maildir-flags
   (foreign-lambda notmuch-status "notmuch_message_tags_to_maildir_flags" notmuch-message))

 (define notmuch-message-freeze
   (foreign-lambda notmuch-status "notmuch_message_freeze" notmuch-message))

 (define notmuch-message-thaw
   (foreign-lambda notmuch-status "notmuch_message_thaw" notmuch-message))

 (define notmuch-message-destroy
   (foreign-lambda void "notmuch_message_destroy" notmuch-message))

 (define notmuch-tags-valid
   (foreign-lambda bool "notmuch_tags_valid" notmuch-tags))

 (define notmuch-tags-get
   (foreign-lambda c-string "notmuch_tags_get" notmuch-tags))

 (define notmuch-tags-move-to-next
   (foreign-lambda void "notmuch_tags_move_to_next" notmuch-tags))

 (define notmuch-tags-destroy
   (foreign-lambda void "notmuch_tags_destroy" notmuch-tags))

 (define notmuch-directory-set-mtime
   (foreign-lambda notmuch-status "notmuch_directory_set_mtime" notmuch-directory time_t))

 (define notmuch-directory-get-mtime
   (foreign-lambda time_t "notmuch_directory_get_mtime" notmuch-directory))

 (define notmuch-directory-get-child-files
   (foreign-lambda notmuch-filenames "notmuch_directory_get_child_files" notmuch-directory))

 (define notmuch-directory-get-child-directories
   (foreign-lambda notmuch-filenames "notmuch_directory_get_child_directories" notmuch-directory))

 (define notmuch-directory-destroy
   (foreign-lambda void "notmuch_directory_destroy" notmuch-directory))

 (define notmuch-filenames-valid
   (foreign-lambda bool "notmuch_filenames_valid" notmuch-filenames))

 (define notmuch-filenames-get
   (foreign-lambda c-string "notmuch_filenames_get" notmuch-filenames))

 (define notmuch-filenames-move-to-next
   (foreign-lambda void "notmuch_filenames_move_to_next" notmuch-filenames))

 (define notmuch-filenames-destroy
   (foreign-lambda void "notmuch_filenames_destroy" notmuch-filenames))

 (define (open-notmuch-db db-path mode)
  (let* ([db ((foreign-primitive notmuch-database
                                 ([c-string path]
                                  [int mode])
                                 "notmuch_database_t *db;"
                                 "int err = notmuch_database_open(path, mode, &db);"
                                 "if ( err != NOTMUCH_STATUS_SUCCESS ) {"
                                 "    C_return(NULL);"
                                 "} else {"
                                 "    C_return(db);"
                                 "}")
              db-path
              mode)])
    (when (not db)
          (abort (make-property-condition 'notmuch-fail
                                          'message (format "Failed to open database"))))
    db))

 (define (call-with-notmuch-db db-path mode thunk)
     (let* ([db (open-notmuch-db db-path mode)]
            [v (thunk db)])
       (notmuch-database-close db)
       v))

 (define (call-with-notmuch-query db q-str thunk)
   (let* ([query (notmuch-query-create db q-str)]
          [v (thunk query)])
     (notmuch-query-destroy query)
     v))

 (define (maybe-print-status-result status #!optional (message ""))
   (unless (= notmuch-status/success status)
     (display (format "\n Error~A: ~A\n"
                      (if (equal? message "")
                          (format " ~A" message)
                          "")
                      (notmuch-status->string status))))
   status)

 (define (map-notmuch-messages db q-str thunk)
   (let ([q (notmuch-query-create db q-str)])
     (let-location ([msgs notmuch-messages])
       (maybe-print-status-result (notmuch-query-search-messages q #$msgs) "executing query")
       (let loop ([m (notmuch-messages-get msgs)])
         (if (notmuch-messages-valid msgs)
             (begin
               (thunk m)
               (notmuch-message-destroy m)
               (notmuch-messages-move-to-next msgs)
               (loop (notmuch-messages-get msgs)))
             (notmuch-messages-destroy msgs))))
     (notmuch-query-destroy q)))

 (define (map-notmuch-threads db q-str thunk)
   (let ([q (notmuch-query-create db q-str)])
     (let-location ([threads notmuch-threads])
       (maybe-print-status-result (notmuch-query-search-messages q #$threads) "executing query")
       (let loop ([t (notmuch-threads-get threads)])
         (if (notmuch-threads-valid threads)
             (begin
               (thunk t)
               (notmuch-thread-destroy t)
               (notmuch-threads-move-to-next threads)
               (loop (notmuch-threads-get threads)))
             (notmuch-threads-destroy threads))))
     (notmuch-query-destroy q)))

 (define (notmuch-status->string status)
   (cond
    ((= status notmuch-status/success) "Success")
    ((= status notmuch-status/read-only-database) "Read-only database")
    ((= status notmuch-status/xapian-exception) "Xapian Exception")
    ((= status notmuch-status/file-error) "File error")
    ((= status notmuch-status/file-not-email) "File not email")
    ((= status notmuch-status/duplicate-message-id) "Duplicate message ID")
    ((= status notmuch-status/null-pointer) "Null pointer")
    ((= status notmuch-status/tag-too-long) "Tag too long")
    ((= status notmuch-status/unbalanced-freeze-thaw) "Unbalanced freeze-thaw")
    ((= status notmuch-status/unbalanced-atomic) "Unbalanced atomic")
    ((= status notmuch-status/unsupported-operation) "Unsupported operation")
    (else "Unknown")))

;; EOF
 )
