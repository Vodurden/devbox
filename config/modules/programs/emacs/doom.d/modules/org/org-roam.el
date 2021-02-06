;;; programs/emacs/doom.d/lang/org.el -*- lexical-binding: t; -*-

;;; The `org-roam-tag-add` can _only_ be called interactively
;;; because it uses `completing-read` for it's arguments outside of
;;; the interactive block.
(defun +org-roam-tag-add-noninteractive (tag)
  "Add tag to Org-roam file."
  (unless org-roam-mode (org-roam-mode))
  (let* ((file (buffer-file-name (buffer-base-buffer)))
         (existing-tags (org-roam--extract-tags-prop file)))
    (when (string-empty-p tag)
      (user-error "Tag can't be empty"))
    (org-roam--set-global-prop
     "roam_tags"
     (combine-and-quote-strings (seq-uniq (cons tag existing-tags))))
    (org-roam-db--insert-tags 'update)
    tag)
  )

(defun +org-roam-tag-delete-noninteractive (tag)
  "Delete a tag from Org-roam file."
  (unless org-roam-mode (org-roam-mode))
  (if-let* ((file (buffer-file-name (buffer-base-buffer)))
            (tags (org-roam--extract-tags-prop file)))
      (org-roam--set-global-prop
       "roam_tags"
       (combine-and-quote-strings (delete tag tags)))
    (org-roam-db--insert-tags 'update)))

(use-package! org-roam-server
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))
