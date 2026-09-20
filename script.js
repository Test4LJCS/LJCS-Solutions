const menuToggle = document.querySelector('.menu-toggle');
const navigation = document.querySelector('.main-nav');

menuToggle?.addEventListener('click', () => {
  const isOpen = navigation.classList.toggle('open');
  menuToggle.setAttribute('aria-expanded', String(isOpen));
});

navigation?.querySelectorAll('a').forEach((link) => {
  link.addEventListener('click', () => {
    navigation.classList.remove('open');
    menuToggle?.setAttribute('aria-expanded', 'false');
  });
});

document.querySelector('#year').textContent = String(new Date().getFullYear());

const contactForm = document.querySelector('#contact-form');
const contactStatus = document.querySelector('#contact-status');

contactForm?.addEventListener('submit', async (event) => {
  event.preventDefault();
  const submitButton = contactForm.querySelector('button[type="submit"]');
  submitButton.disabled = true;
  contactStatus.textContent = 'Enviando sua mensagem...';
  contactStatus.className = 'contact-status';

  try {
    const response = await fetch('/api/contact', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(Object.fromEntries(new FormData(contactForm))),
    });
    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Não foi possível enviar agora.');
    contactForm.reset();
    contactStatus.textContent = 'Mensagem enviada. Em breve entraremos em contato.';
    contactStatus.className = 'contact-status success';
  } catch (error) {
    contactStatus.textContent = error.message;
    contactStatus.className = 'contact-status error';
  } finally {
    submitButton.disabled = false;
  }
});
