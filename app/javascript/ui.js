// Notifications : fermeture automatique et bouton de fermeture
function dismiss(toast) {
  if (!toast || toast.classList.contains("is-leaving")) return
  toast.classList.add("is-leaving")
  toast.addEventListener("animationend", () => toast.remove(), { once: true })
  setTimeout(() => toast.remove(), 600) // au cas où l'animation est désactivée
}

function initToasts() {
  document.querySelectorAll("[data-toast]").forEach((toast) => {
    const delay = parseInt(toast.dataset.toastDelay || "3500", 10)
    toast.style.setProperty("--toast-delay", `${delay}ms`)
    let timer = setTimeout(() => dismiss(toast), delay)

    // La notification reste affichée tant que la souris est dessus
    toast.addEventListener("mouseenter", () => {
      clearTimeout(timer)
      toast.classList.add("is-paused")
    })
    toast.addEventListener("mouseleave", () => {
      toast.classList.remove("is-paused")
      timer = setTimeout(() => dismiss(toast), 1500)
    })
    toast.querySelector("[data-toast-close]")?.addEventListener("click", () => dismiss(toast))
  })
}

// Recherche instantanée et filtre « Nouveaux » dans la liste des appels d'offres
function initSearch() {
  const list = document.querySelector("[data-ao-tiles]")
  if (!list) return
  const input = document.querySelector("[data-ao-search]")
  const filterButtons = document.querySelectorAll("[data-ao-filter]")
  const noResult = document.querySelector("[data-ao-no-result]")
  const normalize = (s) => s.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase()

  // Le filtre est gardé dans l'adresse (?filtre=nouveaux) : il reste actif après un rechargement
  const params = new URLSearchParams(window.location.search)
  let onlyNew = params.get("filtre") === "nouveaux"

  function apply() {
    const query = input ? normalize(input.value.trim()) : ""
    let visible = 0
    list.querySelectorAll("[data-search]").forEach((tile) => {
      const matchSearch = !query || normalize(tile.dataset.search).includes(query)
      const matchFilter = !onlyNew || tile.dataset.new === "true"
      tile.hidden = !(matchSearch && matchFilter)
      if (!tile.hidden) visible++
    })
    if (noResult) noResult.hidden = visible > 0

    filterButtons.forEach((button) => {
      const active = (button.dataset.aoFilter === "new") === onlyNew
      button.classList.toggle("is-active", active)
      button.setAttribute("aria-pressed", active)
    })
  }

  filterButtons.forEach((button) => {
    button.addEventListener("click", () => {
      onlyNew = button.dataset.aoFilter === "new"
      const url = new URL(window.location)
      if (onlyNew) url.searchParams.set("filtre", "nouveaux")
      else url.searchParams.delete("filtre")
      window.history.replaceState({}, "", url)
      apply()
    })
  })
  input?.addEventListener("input", apply)
  apply()
}

// Zone de dépôt du dossier : affiche le fichier choisi et l'effet de survol
function initDropzones() {
  document.querySelectorAll("[data-dropzone]").forEach((zone) => {
    const input = zone.querySelector("input[type=file]")
    const text = zone.querySelector("[data-dropzone-text]")
    if (!input || !text) return
    const initial = text.innerHTML

    const formatSize = (bytes) =>
      bytes > 1024 * 1024 ? `${(bytes / 1024 / 1024).toFixed(1).replace(".", ",")} Mo` : `${Math.max(1, Math.round(bytes / 1024))} Ko`

    input.addEventListener("change", () => {
      const file = input.files[0]
      zone.classList.toggle("has-file", !!file)
      if (file) {
        text.textContent = ""
        const name = document.createElement("strong")
        name.textContent = file.name
        text.append(name, ` (${formatSize(file.size)}) · cliquez pour changer`)
      } else {
        text.innerHTML = initial
      }
    })

    ;["dragenter", "dragover"].forEach((type) => input.addEventListener(type, () => zone.classList.add("is-dragover")))
    ;["dragleave", "drop"].forEach((type) => input.addEventListener(type, () => zone.classList.remove("is-dragover")))
  })
}

// Commentaires façon messagerie : défilement en bas, champ qui s'agrandit, Entrée pour envoyer
function initChat() {
  const thread = document.querySelector("[data-chat-thread]")
  const form = document.querySelector("[data-chat-form]")
  if (!thread || !form) return
  const input = form.querySelector("[data-chat-input]")
  const send = form.querySelector("[data-chat-send]")

  // Afficher les derniers messages (comme sur un téléphone),
  // ou le message qu'on vient de modifier (#commentaire-12)
  thread.style.scrollBehavior = "auto"
  const target = window.location.hash.startsWith("#commentaire-") && document.querySelector(window.location.hash)
  if (target) {
    thread.scrollTop = target.offsetTop - thread.offsetTop - thread.clientHeight / 3
    target.classList.add("is-highlighted")
  } else {
    thread.scrollTop = thread.scrollHeight
  }
  thread.style.scrollBehavior = ""

  initChatEditing(thread)

  const resize = () => {
    input.style.height = "auto"
    input.style.height = `${Math.min(input.scrollHeight, 160)}px`
  }
  const toggleSend = () => { send.disabled = input.value.trim() === "" }

  input.addEventListener("input", () => { resize(); toggleSend() })
  input.addEventListener("keydown", (event) => {
    const hasKeyboard = window.matchMedia("(hover: hover)").matches
    if (event.key === "Enter" && !event.shiftKey && !event.isComposing && hasKeyboard) {
      event.preventDefault()
      if (input.value.trim() !== "") form.requestSubmit()
    }
  })
  form.addEventListener("submit", () => { send.disabled = true })
  toggleSend()

  // Arrivée depuis un email ou après l'envoi (#commentaires) : on place le curseur dans le champ
  if (window.location.hash === "#commentaires") input.focus({ preventScroll: true })
}

// Modifier / supprimer ses propres messages
function initChatEditing(thread) {
  const hasKeyboard = () => window.matchMedia("(hover: hover)").matches
  const autoResize = (el) => { el.style.height = "auto"; el.style.height = `${Math.min(el.scrollHeight, 160)}px` }

  const closeAll = (except) => thread.querySelectorAll(".chat__message.is-selected").forEach((m) => {
    if (m !== except) m.classList.remove("is-selected")
  })

  thread.querySelectorAll("[data-chat-message]").forEach((message) => {
    const bubble = message.querySelector("[data-chat-own]")
    const form = message.querySelector("[data-chat-edit-form]")
    if (!bubble || !form) return
    const input = form.querySelector("[data-chat-edit-input]")
    const original = input.value

    // Sur mobile (pas de survol) : un appui sur sa bulle affiche les boutons
    bubble.addEventListener("click", () => {
      if (hasKeyboard()) return
      closeAll(message)
      message.classList.toggle("is-selected")
    })

    const open = () => {
      message.classList.remove("is-selected")
      message.classList.add("is-editing")
      form.hidden = false
      autoResize(input)
      input.focus()
      input.setSelectionRange(input.value.length, input.value.length)
    }
    const close = () => {
      input.value = original
      form.hidden = true
      message.classList.remove("is-editing")
    }

    message.querySelector("[data-chat-edit]")?.addEventListener("click", open)
    form.querySelector("[data-chat-edit-cancel]").addEventListener("click", close)
    input.addEventListener("input", () => autoResize(input))
    input.addEventListener("keydown", (event) => {
      if (event.key === "Escape") { event.preventDefault(); close() }
      if (event.key === "Enter" && !event.shiftKey && !event.isComposing && hasKeyboard()) {
        event.preventDefault()
        if (input.value.trim() !== "") form.requestSubmit()
      }
    })
  })

  document.addEventListener("click", (event) => {
    if (!event.target.closest("[data-chat-message]")) closeAll()
  })
}

function init() {
  initToasts()
  initSearch()
  initDropzones()
  initChat()
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init)
} else {
  init()
}
