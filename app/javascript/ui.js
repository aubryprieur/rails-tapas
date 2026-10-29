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

function init() {
  initToasts()
  initSearch()
  initDropzones()
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", init)
} else {
  init()
}
