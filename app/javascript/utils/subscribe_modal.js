const subscribeModal = (modalParent, modalElement, backdropElement) => {
  backdropElement.dataset.turboCache = 'false'

  const resizeObserver = new ResizeObserver(() => {
    backdropElement.style.top = `${modalParent.offsetTop}px`
    backdropElement.style.left = `${modalParent.offsetLeft}px`
    modalElement.style.top = `${modalParent.offsetTop}px`
    modalElement.style.left = `${modalParent.offsetLeft}px`
    modalElement.style.width = `${modalParent.offsetWidth}px`
    modalElement.firstElementChild.style.height = `calc(${modalParent.offsetHeight}px - var(--bs-modal-margin) * 2)`
  })

  resizeObserver.observe(modalParent)
  modalElement.addEventListener('hide.bs.modal', () => {
    resizeObserver.unobserve(modalParent)
    modalElement.parentElement.remove()
  })

  return resizeObserver
}

export default subscribeModal
